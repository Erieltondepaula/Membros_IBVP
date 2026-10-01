require('dotenv').config();
const fs = require('fs');
const path = require('path');
const MemberService = require('./services/MemberServicePostgreSQL');
const { PDFDocument, StandardFonts, rgb } = require('pdf-lib');

async function generate() {
  try {
    const members = await MemberService.getAllMembers();
    const withoutAvatar = members.filter(m => !m.avatar_url || m.avatar_url === '');

    const pdfDoc = await PDFDocument.create();
    const timesRomanFont = await pdfDoc.embedFont(StandardFonts.Helvetica);

    const pageSize = { width: 595.28, height: 841.89 }; // A4 in points
    const margin = 40;
    const fontSizeTitle = 18;
    const fontSize = 11;
    const lineHeight = fontSize * 1.4;

    let page = pdfDoc.addPage([pageSize.width, pageSize.height]);
    let y = pageSize.height - margin;

    // Header
    page.drawText('Membros sem avatar', {
      x: margin,
      y: y - fontSizeTitle,
      size: fontSizeTitle,
      font: timesRomanFont,
      color: rgb(0, 0, 0)
    });

    y -= fontSizeTitle + 8;
    page.drawText(`Gerado em: ${new Date().toLocaleString()}`, {
      x: margin,
      y: y - fontSize,
      size: fontSize,
      font: timesRomanFont,
      color: rgb(0.2, 0.2, 0.2)
    });

    y -= fontSize + 12;

    if (withoutAvatar.length === 0) {
      page.drawText('Nenhum membro sem avatar encontrado.', { x: margin, y: y - fontSize, size: fontSize, font: timesRomanFont });
    } else {
      // Columns: Name (max width), ID
      for (let i = 0; i < withoutAvatar.length; i++) {
        const m = withoutAvatar[i];
        const name = (m.nome_completo || `${m.nome || ''} ${m.sobrenome || ''}`).trim();
        const line = `${i + 1}. ${name} (ID: ${m.id})`;

        if (y - lineHeight < margin) {
          page = pdfDoc.addPage([pageSize.width, pageSize.height]);
          y = pageSize.height - margin;
        }

        page.drawText(line, { x: margin, y: y - fontSize, size: fontSize, font: timesRomanFont });
        y -= lineHeight;
      }
    }

    const pdfBytes = await pdfDoc.save();

    const destDir = path.join(process.cwd(), 'Build');
    if (!fs.existsSync(destDir)) fs.mkdirSync(destDir, { recursive: true });
    const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
    const filename = `members_without_avatar-${timestamp}.pdf`;
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
