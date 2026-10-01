require('dotenv').config();
const fs = require('fs');
const path = require('path');
const MemberService = require('./services/MemberServicePostgreSQL');
const { PDFDocument, StandardFonts, rgb } = require('pdf-lib');

function isActive(member) {
  const s = (member.situacao_atual || member.status || member.situacaoAtual || '').toString().toLowerCase();
  return s === 'ativo' || s === 'ativo ';
}

async function generate() {
  try {
    const members = await MemberService.getAllMembers();
    const withoutAvatar = members.filter(m => isActive(m) && (!m.avatar_url || m.avatar_url === ''));

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

    page.drawText(`Total membros ativos sem avatar: ${withoutAvatar.length}`, { x: margin, y: y - fontSize, size: fontSize, font });
    y -= fontSize + 8;

    for (let i = 0; i < withoutAvatar.length; i++) {
      const m = withoutAvatar[i];
      const name = (m.nome_completo || `${m.nome || ''} ${m.sobrenome || ''}`).trim();
      const line = `${i + 1}. ${name} (ID: ${m.id})`;

      if (y - lineHeight < margin) {
        page = pdfDoc.addPage([pageSize.width, pageSize.height]);
        y = pageSize.height - margin;
      }

      page.drawText(line, { x: margin, y: y - fontSize, size: fontSize, font });
      y -= lineHeight;
    }

    const pdfBytes = await pdfDoc.save();

    const destDir = path.join(process.cwd(), 'Build');
    if (!fs.existsSync(destDir)) fs.mkdirSync(destDir, { recursive: true });
    const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
    const filename = `active_members_without_avatar-${timestamp}.pdf`;
    const outPath = path.join(destDir, filename);

    fs.writeFileSync(outPath, pdfBytes);
    console.log('✅ PDF gerado em:', outPath);
    process.exit(0);
  } catch (error) {
    console.error('❌ Erro gerando PDF:', error);
    process.exit(1);
  }
}

generate();
