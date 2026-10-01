require('dotenv').config();
const MemberService = require('./services/MemberServicePostgreSQL');

(async function main(){
  try {
    console.log('🔎 Buscando membros sem avatar (campo avatar_url ausente ou vazio)...\n');
    const members = await MemberService.getAllMembers();
    const withoutAvatar = members.filter(m => !m.avatar_url || m.avatar_url === '');

    console.log(`📋 Total de membros: ${members.length}`);
    console.log(`🚫 Sem avatar: ${withoutAvatar.length}\n`);

    withoutAvatar.forEach(m => {
      const name = m.nome_completo || `${m.nome || ''} ${m.sobrenome || ''}`.trim();
      console.log(`- ${name} (ID: ${m.id})`);
    });

    process.exit(0);
  } catch (error) {
    console.error('❌ Erro ao buscar membros:', error);
    process.exit(1);
  }
})();
