// Exemplo de log de interação
// (deve ser chamado após a inicialização do logger)
const avatarRouter = require('./routes/avatar');
const importarXLSRouter = require('./routes/importarXLS');
const logger = require('./config/logger');
const fs = require('fs');
const path = require('path');

// Arquiva e cria novo log ao iniciar o sistema
function archiveLog(logFileName) {
  const logPath = path.join(__dirname, 'log', logFileName);
  if (fs.existsSync(logPath)) {
    const now = new Date();
    const dateStr = now.toLocaleDateString('pt-BR').replace(/\//g, '-') + '_' + now.toLocaleTimeString('pt-BR').replace(/:/g, '-');
    const archiveDir = path.join(__dirname, 'log', 'archive');
    if (!fs.existsSync(archiveDir)) fs.mkdirSync(archiveDir);
    const archivePath = path.join(archiveDir, `${logFileName.replace('.log','')}_${dateStr}.log`);
    fs.copyFileSync(logPath, archivePath);
    fs.writeFileSync(logPath, '', { flag: 'w' });
    console.log(`🧹 Log ${logFileName} arquivado e limpo.`);
  }
}
archiveLog('error.log');
archiveLog('app.log');

// Local do arquivo: backend/server.js
const express = require('express');
const cors = require('cors');
require('dotenv').config();

// ⚠️ Capturar erros não tratados
process.on('uncaughtException', (error) => {
  console.error('💥 ERRO NÃO CAPTURADO:', error);
  console.error('Stack:', error.stack);
});

process.on('unhandledRejection', (reason, promise) => {
  console.error('💥 PROMISE REJEITADA NÃO TRATADA:', reason);
  console.error('Promise:', promise);
});

// 🐘 POSTGRESQL: Sistema moderno e robusto
const db = require('./config/postgresql');
const MemberService = require('./services/MemberServicePostgreSQL');
const avatarCleanupService = require('./services/avatarCleanupService');

const app = express();

// Configuração do CORS atualizada para permitir a nova porta estável 8081
const corsOptions = {
  origin: [
    'http://localhost:8080', 
    'http://127.0.0.1:8080',
    'http://localhost:8081', 
    'http://127.0.0.1:8081',
    'http://localhost:5173', 
    'http://localhost:5174', 
    'http://localhost:3000'
  ],
  optionsSuccessStatus: 200,
  credentials: true
};
app.use(cors(corsOptions));

app.use(express.json({ limit: '10mb' })); 

// Servir arquivos estáticos (avatares)
const avatarsPath = path.join(__dirname, '..', 'public', 'avatars');
app.use('/avatars', express.static(avatarsPath));
console.log('📁 Servindo avatares de:', avatarsPath);

// Rotas
app.use('/api', avatarRouter);
app.use('/api', importarXLSRouter);

// 🔄 Rotas de sincronização com Google Sheets
const googleSheetsSyncRouter = require('./routes/googleSheetsSync');
app.use('/api', googleSheetsSyncRouter);

// 📤 Upload de logo da igreja
const multer = require('multer');
const logoStorage = multer.diskStorage({
  destination: (req, file, cb) => {
    const logoDir = path.join(__dirname, '..', 'public', 'logos');
    if (!fs.existsSync(logoDir)) {
      fs.mkdirSync(logoDir, { recursive: true });
    }
    cb(null, logoDir);
  },
  filename: (req, file, cb) => {
    const ext = path.extname(file.originalname);
    cb(null, `church-logo${ext}`);
  }
});

const logoUpload = multer({ storage: logoStorage });

app.post('/api/upload-church-logo', logoUpload.single('logo'), (req, res) => {
  try {
    console.log('📤 Recebido request de upload de logo');
    console.log('📁 Arquivo:', req.file);
    
    if (!req.file) {
      console.error('❌ Nenhum arquivo recebido');
      return res.status(400).json({ error: 'Nenhum arquivo enviado' });
    }

    const logoUrl = `/logos/${req.file.filename}`;
    console.log(`✅ Logo da igreja salva: ${logoUrl}`);
    logger.info(`✅ Logo da igreja enviada: ${logoUrl}`);
    
    res.json({ logo_url: logoUrl });
  } catch (error) {
    console.error('❌ Erro ao fazer upload da logo:', error);
    logger.error('Erro ao fazer upload da logo:', error);
    res.status(500).json({ error: 'Erro ao fazer upload da logo' });
  }
});

// Servir logos
const logosPath = path.join(__dirname, '..', 'public', 'logos');
app.use('/logos', express.static(logosPath));
console.log('🏢 Servindo logos de:', logosPath);


// 🔍 NOVA FUNÇÃO: Varre o banco no boot e remove avatares que não existem fisicamente
async function verifyAvatarsOnStartup() {
  logger.info('🔍 Iniciando verificação de integridade dos avatares na inicialização...');
  try {
    const result = await db.query("SELECT id, avatar_url FROM membros WHERE avatar_url IS NOT NULL AND avatar_url != ''");
    // Adaptação caso db.query retorne o array direto ou um objeto com .rows
    const members = Array.isArray(result) ? result : (result.rows || []);
    
    let missingCount = 0;

    for (const member of members) {
      if (!member.avatar_url) continue;
      
      const filename = member.avatar_url.split('/').pop();
      const filePath = path.join(avatarsPath, filename);

      // Se o arquivo não existir fisicamente, limpa do banco
      if (!fs.existsSync(filePath)) {
        await db.query("UPDATE membros SET avatar_url = NULL WHERE id = $1", [member.id]);
        missingCount++;
      }
    }
    logger.info(`✅ Verificação de avatares concluída. ${missingCount} referências inválidas removidas do banco.`);
  } catch (error) {
    logger.error(`❌ Erro ao verificar avatares na inicialização: ${error.message}`);
  }
}

// Reconecta no banco avatares salvos no disco com o ID do membro.
async function restoreAvatarReferencesOnStartup() {
  logger.info('🔗 Verificando avatares salvos sem vínculo no banco...');

  try {
    if (!fs.existsSync(avatarsPath)) return;

    const members = await db.query(
      "SELECT id FROM membros WHERE avatar_url IS NULL OR avatar_url = ''"
    );
    const imageExtensions = new Set(['.jpg', '.jpeg', '.png', '.gif', '.webp']);
    const filesByMemberId = new Map();

    for (const entry of fs.readdirSync(avatarsPath, { withFileTypes: true })) {
      const extension = path.extname(entry.name).toLowerCase();
      if (entry.isFile() && imageExtensions.has(extension)) {
        filesByMemberId.set(path.parse(entry.name).name, entry.name);
      }
    }

    let restoredCount = 0;
    for (const member of members) {
      const filename = filesByMemberId.get(String(member.id));
      if (!filename) continue;

      await db.execute(
        'UPDATE membros SET avatar_url = $1, updated_at = NOW() WHERE id = $2',
        [`/avatars/${filename}`, member.id]
      );
      restoredCount++;
      logger.info(`🔗 Avatar reconectado ao membro ${member.id}: ${filename}`);
    }

    logger.info(`✅ ${restoredCount} referência(s) de avatar restaurada(s).`);
  } catch (error) {
    logger.error(`❌ Erro ao restaurar referências de avatares: ${error.message}`);
  }
}

// Remove arquivos de avatar que não possuem referência no banco.
async function cleanupOrphanAvatarsOnStartup() {
  logger.info('🧹 Iniciando limpeza de avatares órfãos na inicialização...');

  try {
    if (!fs.existsSync(avatarsPath)) {
      logger.info(`⚠️ Pasta de avatares não encontrada: ${avatarsPath}`);
      return;
    }

    const result = await db.query(
      "SELECT DISTINCT avatar_url FROM membros WHERE avatar_url IS NOT NULL AND avatar_url != ''"
    );
    const members = Array.isArray(result) ? result : (result.rows || []);
    const avatarsInUse = new Set(
      members
        .map(member => path.basename(member.avatar_url || ''))
        .filter(Boolean)
    );
    const ignoredFiles = new Set(['.gitkeep', 'placeholder.png']);
    const imageExtensions = new Set(['.jpg', '.jpeg', '.png', '.gif', '.webp']);
    let removedCount = 0;

    for (const entry of fs.readdirSync(avatarsPath, { withFileTypes: true })) {
      const extension = path.extname(entry.name).toLowerCase();
      if (
        !entry.isFile() ||
        ignoredFiles.has(entry.name) ||
        !imageExtensions.has(extension) ||
        avatarsInUse.has(entry.name)
      ) {
        continue;
      }

      try {
        fs.unlinkSync(path.join(avatarsPath, entry.name));
        removedCount++;
        logger.info(`🗑️ Avatar órfão removido: ${entry.name}`);
      } catch (error) {
        logger.error(`❌ Erro ao remover avatar ${entry.name}: ${error.message}`);
      }
    }

    logger.info(
      removedCount === 0
        ? '✅ Nenhum avatar órfão encontrado.'
        : `✅ Limpeza concluída: ${removedCount} avatar(es) órfão(s) removido(s).`
    );
  } catch (error) {
    logger.error(`❌ Erro na limpeza de avatares órfãos: ${error.message}`);
  }
}


// 🐘 INICIALIZAÇÃO POSTGRESQL
async function initializeSystem() {
  logger.info('🔄 Inicializando sistema com PostgreSQL...');
  try {
    logger.info('📡 Conectando ao banco...');
    await db.connect();
    logger.info('✅ Conectado ao PostgreSQL com sucesso!');
    
    // Verificar se o schema existe
    logger.info('🏥 Executando health check...');
    const healthCheck = await db.healthCheck();
    logger.info(`✅ Health check completo: ${healthCheck.status}`);

    // 🔥 Executar limpeza de avatares fantasmas antes de liberar o servidor
    await restoreAvatarReferencesOnStartup();
    await verifyAvatarsOnStartup();
    await cleanupOrphanAvatarsOnStartup();

    logger.info('✨ Inicialização concluída!');
    return true; // ✅ Retorna sucesso
  } catch (err) {
    logger.error(`❌ Falha ao conectar com PostgreSQL: ${err}`);
    logger.info('💡 Execute: node scripts/setupPostgreSQL.js');
    process.exit(1);
  }
}


// --- ROTAS DA API ---

// Função auxiliar para converter campos do banco (snake_case) para frontend (camelCase)
function convertMemberToFrontend(member) {
  if (!member) return null;
  
  // 🔍 VERIFICAÇÃO EM TEMPO REAL: Valida se a imagem existe na pasta
  let validAvatarUrl = member.avatar_url;
  if (validAvatarUrl) {
    const filename = validAvatarUrl.split('/').pop();
    const filePath = path.join(avatarsPath, filename);
    if (!fs.existsSync(filePath)) {
      validAvatarUrl = null; // Se não existe fisicamente, oculta do frontend
    }
  }
  
  // Retorna APENAS os campos no formato camelCase, sem duplicação
  return {
    id: member.id,
    idExterno: member.id_externo,
    nome: member.nome,
    sobrenome: member.sobrenome,
    nomeCompleto: member.nome_completo,
    dataNascimento: member.data_nascimento,
    idade: member.idade,
    mes: member.mes,
    telefone: member.telefone,
    sexo: member.sexo,
    observacoes: member.observacoes,
    statusCivil: member.status_civil,
    conjuge: member.conjuge,
    parentesco: member.parentesco,
    rua: member.rua,
    numero: member.numero,
    bairro: member.bairro,
    cidade: member.cidade,
    estado: member.estado,
    cep: member.cep,
    batizado: member.batizado,
    membro: member.membro,
    situacaoAtual: member.situacao_atual,
    lider: member.lider,
    professorEBQ: member.e_professor_ebq,
    faixaEtaria: member.faixa_etaria,
    pequenoGrupo: member.pequeno_grupo,
    grupo: member.grupo,
    numeroDomes: member.numerodomes,
    motivoDesligamento: member.motivo_desligamento,
    dataDesligamento: member.data_desligamento,
    dataBatismo: member.data_batismo,
    avatarUrl: validAvatarUrl, // <-- URL validada injetada aqui
    createdAt: member.created_at,
    updatedAt: member.updated_at
  };
}

// 🐘 ROTA: Buscar TODOS os membros do PostgreSQL
app.get('/api/members', async (req, res) => {
  try {
    const members = await MemberService.getAllMembers();
    // Converter todos os membros para o formato frontend
    const convertedMembers = members.map(convertMemberToFrontend);
    res.json(convertedMembers);
  } catch (error) {
    logger.error(`❌ Erro ao buscar membros: ${error}`);
    logger.info('🔎 Tentativa de buscar todos os membros falhou.');
    res.status(500).json({ message: 'Erro ao buscar membros do PostgreSQL.' });
  }
});

// ROTA: Membros ativos sem avatar (JSON) - DEVE VIR ANTES de /api/members/:id
app.get('/api/members/ativos-sem-avatar', async (req, res) => {
  try {
    const members = await MemberService.getAllMembers();
    // Usa a conversão que já verifica se o avatar físico existe
    const converted = members.map(convertMemberToFrontend);
    
    const activeNoAvatar = converted.filter(m => {
      const situacao = (m.situacaoAtual || '').toString().toLowerCase();
      const isActive = situacao === 'ativo';
      const noAvatar = !m.avatarUrl || m.avatarUrl === '';
      return isActive && noAvatar;
    });
    
    res.json(activeNoAvatar);
  } catch (error) {
    logger.error('Erro ao buscar membros ativos sem avatar:', error);
    res.status(500).json({ message: 'Erro ao buscar membros ativos sem avatar.' });
  }
});

// ROTA: Membros ativos sem avatar (PDF download)
app.get('/api/members/ativos-sem-avatar/pdf', async (req, res) => {
  try {
    const { PDFDocument, StandardFonts, rgb } = require('pdf-lib');
    const members = await MemberService.getAllMembers();
    const converted = members.map(convertMemberToFrontend);
    
    const activeNoAvatar = converted.filter(m => {
      const situacao = (m.situacaoAtual || '').toString().toLowerCase();
      const isActive = situacao === 'ativo';
      const noAvatar = !m.avatarUrl || m.avatarUrl === '';
      return isActive && noAvatar;
    });

    const pdfDoc = await PDFDocument.create();
    const font = await pdfDoc.embedFont(StandardFonts.Helvetica);
    const pageSize = { width: 595.28, height: 841.89 };
    const margin = 40;
    const fontSizeTitle = 18;
    const fontSize = 11;
    const lineHeight = fontSize * 1.4;

    let page = pdfDoc.addPage([pageSize.width, pageSize.height]);
    let y = pageSize.height - margin;
    page.drawText('Membros ATIVOS sem avatar', { x: margin, y: y - fontSizeTitle, size: fontSizeTitle, font, color: rgb(0,0,0) });
    y -= fontSizeTitle + 8;
    page.drawText(`Gerado em: ${new Date().toLocaleString()}`, { x: margin, y: y - fontSize, size: fontSize, font, color: rgb(0.2,0.2,0.2) });
    y -= fontSize + 12;
    page.drawText(`Total membros ativos sem avatar: ${activeNoAvatar.length}`, { x: margin, y: y - fontSize, size: fontSize, font });
    y -= fontSize + 8;

    for (let i = 0; i < activeNoAvatar.length; i++) {
      const m = activeNoAvatar[i];
      const name = (m.nomeCompleto || `${m.nome || ''} ${m.sobrenome || ''}`).trim();
      const line = `${i + 1}. ${name} (ID: ${m.id})`;
      if (y - lineHeight < margin) {
        page = pdfDoc.addPage([pageSize.width, pageSize.height]);
        y = pageSize.height - margin;
      }
      page.drawText(line, { x: margin, y: y - fontSize, size: fontSize, font });
      y -= lineHeight;
    }

    const pdfBytes = await pdfDoc.save();
    res.setHeader('Content-Type', 'application/pdf');
    res.setHeader('Content-Disposition', 'attachment; filename="active_members_without_avatar.pdf"');
    res.send(Buffer.from(pdfBytes));
  } catch (error) {
    logger.error('Erro ao gerar PDF de membros ativos sem avatar:', error);
    res.status(500).json({ message: 'Erro ao gerar PDF.' });
  }
});

// ✅ NOVA ROTA: Buscar membro por ID
app.get('/api/members/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const member = await MemberService.getMemberById(id);
    if (!member) {
        return res.status(404).json({ message: 'Membro não encontrado.' });
    }
    // Converter membro para o formato frontend
    res.json(convertMemberToFrontend(member));
  } catch (error) {
    logger.error(`❌ Erro ao buscar membro ${req.params.id}: ${error}`);
    logger.info(`🔎 Tentativa de buscar membro por ID (${req.params.id}) falhou.`);
    res.status(500).json({ message: 'Erro ao buscar membro.' });
  }
});

// 🐘 ROTA: Criar novo membro com ID personalizado
app.post('/api/members', async (req, res) => {
  try {
    const newMember = await MemberService.insertNewMember(req.body);
    res.status(201).json(newMember);
  } catch (error) {
    logger.error(`❌ Erro ao criar membro: ${error}`);
    res.status(400).json({ message: error.message || 'Erro ao criar membro no PostgreSQL.' });
  }
});

// ✅ NOVA ROTA: Atualizar membro
app.put('/api/members/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const updatedMember = await MemberService.updateMember(id, req.body);
    if (!updatedMember) {
        return res.status(404).json({ message: 'Membro não encontrado.' });
    }
    // Converter membro para o formato frontend
    res.json(convertMemberToFrontend(updatedMember));
  } catch (error) {
    logger.error(`❌ Erro ao atualizar membro ${req.params.id}: ${error}`);
    res.status(400).json({ message: error.message || 'Erro ao atualizar membro.' });
  }
});

// ✅ NOVA ROTA: Deletar membro
app.delete('/api/members/:id', async (req, res) => {
  try {
    const { id } = req.params;
    await MemberService.deleteMember(id);
    res.json({ message: 'Membro removido com sucesso!' });
  } catch (error) {
    logger.error(`❌ Erro ao deletar membro ${req.params.id}: ${error}`);
    res.status(500).json({ message: 'Erro ao deletar membro.' });
  }
});

// 🐘 ROTA: Importar membros com anti-duplicação e IDs personalizados
app.post('/api/members/batch', async (req, res) => {
  logger.info("➡️ [LOG] Recebida requisição de importação em massa");
  const { members, replaceAll } = req.body;

  if (!members || !Array.isArray(members)) {
    logger.error("❌ [ERRO] 'members' não é um array ou não foi fornecido.");
    return res.status(400).json({ message: "Formato de dados inválido." });
  }
  
  logger.info(`➡️ [LOG] Recebidos ${members.length} membros. Substituir todos: ${replaceAll}`);
  logger.info(`🎯 [LOG] IDs personalizados serão gerados automaticamente (formato: AA20253010104302)`);

  try {
    if (replaceAll) {
      logger.info("🧠 [LOG] Modo REPLACE ALL - Sistema inteligente ativado");
      logger.info("📋 [LOG] Preservando avatars e atualizando apenas campos diferentes");
    } else {
      logger.info("🔄 [LOG] Modo UPDATE - Sistema inteligente ativado");
    }

    // 🎯 SISTEMA ANTI-DUPLICAÇÃO: Verificar duplicatas por Nome + Data Nascimento
    const processedMembers = [];
    const duplicateChecks = [];
    
    for (const member of members) {
      const uniqueKey = `${(member.nome || '').trim().toLowerCase()}_${member.dataNascimento || member.data_nascimento || ''}`;
      
      if (!duplicateChecks.includes(uniqueKey)) {
        duplicateChecks.push(uniqueKey);
        
        if (processedMembers.length === 0) {
          logger.info(`🔍 [DEBUG] Primeiro membro - situacao_atual original: "${member.situacao_atual}"`);
          logger.info(`🔍 [DEBUG] Chaves do membro:`, Object.keys(member).filter(k => k.includes('situacao')));
        }
        
        processedMembers.push({
          ...member,
          id: undefined,
          nome_completo: member.nomeCompleto || member.nome_completo,
          data_nascimento: member.dataNascimento || member.data_nascimento,
          status_civil: member.statusCivil || member.status_civil,
          situacao_atual: member.situacao_atual || member.situacaoAtual,
          professor_ebq: member.professorEBQ || member.professor_ebq,
          pequeno_grupo: member.pequeno_grupo || false,
          data_batismo: member.dataBatismo || member.data_batismo,
          data_membresia: member.dataMembresia || member.data_membresia,
          data_desligamento: member.dataDesligamento || member.data_desligamento
        });
      } else {
        logger.info(`⚠️ [DUPLICATA] Membro duplicado ignorado: ${member.nome}`);
      }
    }
    
  logger.info(`📊 [LOG] ${processedMembers.length} membros únicos serão processados`);

    const results = await MemberService.importMembers(processedMembers);
    
    const successCount = results.filter(r => r.success).length;
    const errorCount = results.filter(r => !r.success).length;
    const duplicateCount = members.length - processedMembers.length;
    const insertedCount = results.filter(r => r.success && r.action === 'inserted').length;
    const updatedCount = results.filter(r => r.success && r.action === 'updated').length;
    
  logger.info(`✅ [LOG] Importação concluída:`);
  logger.info(`   - ${successCount} sucessos (${insertedCount} novos, ${updatedCount} atualizados)`);
  logger.info(`   - ${errorCount} erros`);
  logger.info(`   - ${duplicateCount} duplicatas evitadas`);
    
    const successResults = results.filter(r => r.success && r.id);
    if (successResults.length > 0) {
      logger.info(`🆔 [EXEMPLOS] IDs: ${successResults.slice(0, 3).map(r => r.id).join(', ')}`);
    }
    
    logger.info(`🧹 [LOG] Executando limpeza automática de avatars...`);
    try {
      const cleanupResult = await MemberService.cleanupUnusedAvatars();
      logger.info(`✅ [LOG] Limpeza concluída: ${cleanupResult.removidos} removidos, ${cleanupResult.mantidos} mantidos`);
    } catch (cleanupError) {
      logger.error(`⚠️ [LOG] Erro na limpeza de avatars: ${cleanupError.message}`);
    }

    res.json({
      message: `Importação concluída: ${successCount} membros com IDs personalizados, ${errorCount} erros, ${duplicateCount} duplicatas evitadas.`,
      results,
      stats: { 
        success: successCount, 
        errors: errorCount, 
        duplicates: duplicateCount,
        total_processed: processedMembers.length,
        total_received: members.length
      }
    });
    
  } catch (error) {
    logger.error(`❌ [ERRO GRAVE] Falha na importação: ${error}`);
    res.status(400).json({ 
      message: error.message || 'Erro ao importar membros para o PostgreSQL.',
      error: error.message 
    });
  }
});

// 🐘 ROTA: Estatísticas gerais do PostgreSQL
app.get('/api/statistics', async (req, res) => {
  try {
    const stats = await MemberService.getStatistics();
    res.json(stats);
  } catch (error) {
    logger.error(`❌ Erro ao buscar estatísticas: ${error}`);
    res.status(500).json({ message: 'Erro ao buscar estatísticas.' });
  }
});

// 🧪 ROTA: Testar geração de ID personalizado
app.get('/api/test-id/:nome/:sobrenome', async (req, res) => {
  try {
    const { nome, sobrenome } = req.params;
    const customId = await MemberService.generateCustomId(nome, `${nome} ${sobrenome}`);
    res.json({ 
      nome, 
      sobrenome, 
      id_gerado: customId, 
      formato: 'AA20253010104302' 
    });
  } catch (error) {
    logger.error(`❌ Erro ao gerar ID teste: ${error}`);
    res.status(500).json({ message: 'Erro ao gerar ID personalizado.' });
  }
});

// 📤 ROTAS: Importação Interativa
const importacaoRoutes = require('./routes/importacao');
app.use('/api/importacao', importacaoRoutes);

// ⚙️ CONFIGURAÇÕES DA IGREJA
app.get('/api/church-settings', async (req, res) => {
  try {
    console.log('📥 GET /api/church-settings - Requisição recebida');
    const result = await db.query('SELECT * FROM church_settings LIMIT 1');
    console.log('✅ Query executada, linhas:', result.length);
    
    if (result.length === 0) {
      console.log('⚠️  Nenhuma configuração encontrada');
      return res.status(404).json({ error: 'Configurações não encontradas' });
    }
    
    console.log('✅ Retornando configurações:', result[0]);
    res.json(result[0]);
  } catch (error) {
    console.error('❌ Erro ao buscar configurações da igreja:');
    console.error('  Mensagem:', error.message);
    console.error('  Stack:', error.stack);
    logger.error('Erro ao buscar configurações da igreja:', error);
    res.status(500).json({ error: 'Erro ao buscar configurações', details: error.message });
  }
});

app.put('/api/church-settings', async (req, res) => {
  try {
    console.log('📥 PUT /api/church-settings - Requisição recebida');
    console.log('📦 Body:', req.body);
    
    const { nome, denominacao, telefone, email, endereco, cidade, estado, cep, pais, logo_url } = req.body;
    
    const existingResult = await db.query('SELECT id FROM church_settings LIMIT 1');
    console.log('🔍 Configurações existentes:', existingResult.length);
    
    if (existingResult.length === 0) {
      console.log('➕ Inserindo nova configuração...');
      const insertResult = await db.query(`
        INSERT INTO church_settings (nome, denominacao, telefone, email, endereco, cidade, estado, cep, pais, logo_url)
        VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)
        RETURNING *
      `, [nome, denominacao, telefone, email, endereco, cidade, estado, cep, pais, logo_url]);
      
      console.log('✅ Configuração criada:', insertResult[0].id);
      logger.info('✅ Configurações da igreja criadas');
      return res.json(insertResult[0]);
    } else {
      console.log('🔄 Atualizando configuração existente...');
      const updateResult = await db.query(`
        UPDATE church_settings
        SET nome = $1, denominacao = $2, telefone = $3, email = $4, 
            endereco = $5, cidade = $6, estado = $7, cep = $8, pais = $9, logo_url = $10,
            updated_at = CURRENT_TIMESTAMP
        WHERE id = $11
        RETURNING *
      `, [nome, denominacao, telefone, email, endereco, cidade, estado, cep, pais, logo_url, existingResult[0].id]);
      
      console.log('✅ Configuração atualizada:', updateResult[0].id);
      logger.info('✅ Configurações da igreja atualizadas');
      return res.json(updateResult[0]);
    }
  } catch (error) {
    console.error('❌ Erro ao atualizar configurações da igreja:');
    console.error('  Mensagem:', error.message);
    console.error('  Stack:', error.stack);
    logger.error('Erro ao atualizar configurações da igreja:', error);
    res.status(500).json({ error: 'Erro ao atualizar configurações', details: error.message });
  }
});

const PORT = process.env.PORT || 5001;

// 🐘 INICIALIZAR POSTGRESQL E SUBIR SERVIDOR
initializeSystem().then(() => {
  const server = app.listen(PORT, () => {
    logger.info(`🚀 Servidor rodando na porta ${PORT}`);
    logger.info(`🗄️ Banco PostgreSQL: dashboard_membros`);
    logger.info(`🌐 API disponível em: http://localhost:${PORT}`);
    logger.info(`🆔 IDs personalizados: formato AA20253010104302`);
    logger.info(`🧪 Teste ID: http://localhost:${PORT}/api/test-id/ABNER/LIMA`);
    logger.info(`✅ Servidor ATIVO - aguardando requisições...`);
    
    // 🧹 Limpeza automática de avatars DESATIVADA (para não afetar a inicialização)
    // avatarCleanupService.startAutoCleanup(24);
    logger.info(`🛑 Limpeza automática desativada`);
  });

  // Prevenir que o processo termine inesperadamente
  server.on('error', (error) => {
    logger.error(`❌ Erro no servidor: ${error.message}`);
    logger.error(`❌ Stack: ${error.stack}`);
  });

  // Handler para encerramento gracioso
  process.on('SIGINT', () => {
    logger.info('\n🛑 Encerrando servidor...');
    avatarCleanupService.stopAutoCleanup(); // Parar limpeza automática
    server.close(() => {
      logger.info('✅ Servidor fechado com sucesso');
      process.exit(0);
    });
  });
}).catch(error => {
  logger.error(`❌ Falha crítica na inicialização:`);
  logger.error(`❌ Mensagem: ${error.message}`);
  logger.error(`❌ Stack: ${error.stack}`);
  console.error('❌ ERRO COMPLETO:', error);
  process.exit(1);
});