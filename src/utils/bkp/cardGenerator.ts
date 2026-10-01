import { PDFDocument, PDFPage, rgb, PDFImage } from 'pdf-lib';

interface CardData {
  nome: string;
  id: string;
  telefone?: string;
  Igreja?: string;
  avatar_url?: string;
}

/**
 * Gera uma carteirinha de membro em PDF (tamanho cartão de crédito: 85 x 54 mm)
 * @param member Dados do membro
 * @returns Promise<Uint8Array> bytes do PDF
 */
export async function generateMemberCard(member: CardData): Promise<Uint8Array> {
  const pdfDoc = await PDFDocument.create();
  
  // Tamanho cartão de crédito: 85 x 54 mm em pontos (72 DPI)
  // 85 mm = 85 * 72 / 25.4 ≈ 240.94 pt
  // 54 mm = 54 * 72 / 25.4 ≈ 152.91 pt
  const cardWidth = 241; // 85 mm
  const cardHeight = 153; // 54 mm
  
  const page = pdfDoc.addPage([cardWidth, cardHeight]);
  
  // Cores da identidade visual (azul da Igreja Batista)
  const primaryBlue = rgb(0.125, 0.149, 0.4); // #1F2668
  const accentYellow = rgb(1, 0.85, 0); // #FFDD00
  const white = rgb(1, 1, 1);
  const darkGray = rgb(0.2, 0.2, 0.2);
  
  const margin = 8;
  let currentY = cardHeight - margin;
  
  // Fundo azul (barra superior)
  page.drawRectangle({
    x: 0,
    y: cardHeight - 25,
    width: cardWidth,
    height: 25,
    color: primaryBlue,
  });
  
  // Barra amarela
  page.drawRectangle({
    x: 0,
    y: cardHeight - 28,
    width: cardWidth,
    height: 3,
    color: accentYellow,
  });
  
  try {
    // Tentar buscar e adicionar avatar se disponível
    if (member.avatar_url) {
      try {
        const response = await fetch(member.avatar_url);
        if (response.ok) {
          const buffer = await response.arrayBuffer();
          
          // Detectar tipo de imagem
          let image: PDFImage;
          const contentType = response.headers.get('content-type');
          
          if (contentType?.includes('png')) {
            image = await pdfDoc.embedPng(buffer);
          } else if (contentType?.includes('jpeg') || contentType?.includes('jpg')) {
            image = await pdfDoc.embedJpg(buffer);
          } else {
            // Tentar como PNG por padrão
            image = await pdfDoc.embedPng(buffer);
          }
          
          // Desenhar avatar à esquerda (50x50 px)
          const avatarSize = 48;
          page.drawImage(image, {
            x: margin,
            y: cardHeight - 28 - avatarSize - 5,
            width: avatarSize,
            height: avatarSize,
          });
        }
      } catch (error) {
        console.warn('Erro ao carregar avatar:', error);
      }
    }
  } catch (error) {
    console.warn('Erro ao processar imagem:', error);
  }
  
  // Texto de título (espaço reservado para logo/texto "MEMBRO")
  const titleFont = await pdfDoc.embedFont('Helvetica-Bold');
  const regularFont = await pdfDoc.embedFont('Helvetica');
  const smallFont = await pdfDoc.embedFont('Helvetica');
  
  // Nome do membro (maior destaque)
  page.drawText(member.nome.toUpperCase(), {
    x: 60,
    y: cardHeight - 35,
    size: 9,
    font: titleFont,
    color: darkGray,
    maxWidth: cardWidth - 68 - margin,
  });
  
  currentY = cardHeight - 50;
  
  // ID do membro
  page.drawText(`ID: ${member.id}`, {
    x: margin,
    y: currentY,
    size: 7,
    font: regularFont,
    color: darkGray,
  });
  
  currentY -= 9;
  
  // Telefone se existir
  if (member.telefone) {
    page.drawText(`Tel: ${member.telefone}`, {
      x: margin,
      y: currentY,
      size: 7,
      font: regularFont,
      color: darkGray,
      maxWidth: cardWidth - 2 * margin,
    });
    currentY -= 9;
  }
  
  // Parte inferior com informações da Igreja
  const churchSection = 20;
  page.drawRectangle({
    x: 0,
    y: 0,
    width: cardWidth,
    height: churchSection,
    color: primaryBlue,
  });
  
  const churchName = member.Igreja || 'IGREJA BATISTA EM VILA PALESTINA';
  page.drawText(churchName.toUpperCase(), {
    x: margin,
    y: 4,
    size: 5,
    font: smallFont,
    color: white,
    maxWidth: cardWidth - 2 * margin,
  });
  
  const pdfBytes = await pdfDoc.save();
  return pdfBytes;
}
