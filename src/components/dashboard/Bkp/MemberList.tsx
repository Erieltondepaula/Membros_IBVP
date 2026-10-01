// Local do arquivo: src/components/dashboard/MemberList.tsx
// ✅ CÓDIGO ATUALIZADO - Otimizado com Índice Alfabético de A a Z

import { useState, useMemo } from 'react';
import { Member, MemberFilters } from '@/types/member';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from '@/components/ui/table';
import { Badge } from '@/components/ui/badge';
import { Button } from '@/components/ui/button';
import { Checkbox } from '@/components/ui/checkbox';
import { Label } from '@/components/ui/label';
import { Eye, ArrowUpDown, ArrowUp, ArrowDown, Edit, RefreshCw, ChevronLeft, ChevronRight, ChevronsLeft, ChevronsRight, FileText } from 'lucide-react';
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter } from '@/components/ui/dialog';
import ActiveNoAvatarModal from '@/components/ActiveNoAvatarModal';
import { MemberDetails } from './MemberDetails';
import { MemberEdit } from './MemberEdit';
import { calculateAge, getMemberType } from '@/utils/memberUtils';
import { exportToPDF } from '@/utils/pdfUtils';

const ITEMS_PER_PAGE = 25;

interface MemberListProps {
  members: Member[];
  onMemberUpdate: (member: Member) => void;
  onRefresh: () => void;
  sortField: keyof Member | 'idade' | 'tipo' | null;
  sortDirection: 'asc' | 'desc';
  onSort: (field: keyof Member | 'idade' | 'tipo') => void;
  filters?: MemberFilters; 
}

const MemberTypeBadge = ({ type }: { type: string }) => {
  const getVariantClass = () => {
    switch (type) {
      case 'Membro':
        return 'bg-success/10 text-success border-success/20 hover:bg-success/10';
      case 'Batizado Congregado':
        return 'text-primary font-semibold';
      case 'Congregado':
        return 'bg-warning/10 text-warning border-warning/20 hover:bg-warning/10';
      case 'Desligado':
        return 'bg-destructive/10 text-destructive border-destructive/20 hover:bg-destructive/10';
      default:
        return 'bg-muted text-muted-foreground border-border hover:bg-muted';
    }
  };

  if (type === 'Batizado Congregado') {
    return <span className={getVariantClass()}>{type}</span>
  }
  
  return <Badge className={getVariantClass()}>{type}</Badge>;
};

export const MemberList = ({ members, onMemberUpdate, onRefresh, sortField, sortDirection, onSort, filters = {} }: MemberListProps) => {
  const [selectedMember, setSelectedMember] = useState<Member | null>(null);
  const [editingMember, setEditingMember] = useState<Member | null>(null);
  const [isDetailsOpen, setIsDetailsOpen] = useState(false);
  const [isEditOpen, setIsEditOpen] = useState(false);
  const [currentPage, setCurrentPage] = useState(1);
  
  const [selectedLetter, setSelectedLetter] = useState<string | null>(null);
  const alfabeto = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('');

  const [isPdfConfigOpen, setIsPdfConfigOpen] = useState(false);
  const [activeNoAvatarOpen, setActiveNoAvatarOpen] = useState(false);
  const [showAge, setShowAge] = useState(true);
  const [showPhoto, setShowPhoto] = useState(true);
  const [showBirthdayWeekday, setShowBirthdayWeekday] = useState(true);
  const [showType, setShowType] = useState(true);

  const letrasAtivas = useMemo(() => {
    const conjunto = new Set<string>();
    members.forEach(m => {
      const letra = (m.nomeCompleto || m.nome || '').trim().charAt(0).toUpperCase();
      if (letra) conjunto.add(letra);
    });
    return conjunto;
  }, [members]);

  const handleLetterSelect = (letter: string | null) => {
    setSelectedLetter(letter);
    setCurrentPage(1); 
  };

  const membersFiltradosPorLetra = useMemo(() => {
    if (!selectedLetter) return members;
    return members.filter(member => {
      const nomeParaChecar = (member.nomeCompleto || member.nome || '').trim().toUpperCase();
      return nomeParaChecar.startsWith(selectedLetter);
    });
  }, [members, selectedLetter]);

  const handleOpenPdfConfig = () => {
    setIsPdfConfigOpen(true);
  };

  const handleExportPDF = () => {
    const logoUrlRaw = localStorage.getItem('church-logo');
    const churchNameRaw = localStorage.getItem('church-name');
    const logoUrl = logoUrlRaw ? JSON.parse(logoUrlRaw) : null;
    const churchName = churchNameRaw ? JSON.parse(churchNameRaw) : 'Relatório de Membros';
    
    exportToPDF(membersFiltradosPorLetra, filters, logoUrl, churchName, 'relatorio-membros', showAge, showPhoto, showBirthdayWeekday, showType);
    setIsPdfConfigOpen(false);
  };

  const totalPages = Math.ceil(membersFiltradosPorLetra.length / ITEMS_PER_PAGE);

  const paginatedMembers = useMemo(() => {
    const startIndex = (currentPage - 1) * ITEMS_PER_PAGE;
    const endIndex = startIndex + ITEMS_PER_PAGE;
    return membersFiltradosPorLetra.slice(startIndex, endIndex);
  }, [membersFiltradosPorLetra, currentPage]);

  if (currentPage > totalPages && totalPages > 0) {
    setCurrentPage(1);
  }

  const getSortIcon = (field: string) => {
    if (sortField !== field) return <ArrowUpDown className="h-4 w-4 text-muted-foreground" />;
    return sortDirection === 'asc' ? <ArrowUp className="h-4 w-4" /> : <ArrowDown className="h-4 w-4" />;
  };
  
  const handleViewDetails = (member: Member) => {
    setSelectedMember(member);
    setIsDetailsOpen(true);
  };

  const handleEditClick = (member: Member) => {
    setEditingMember(member);
    setIsEditOpen(true);
  };
  
  const handleSaveEdit = (updatedMember: Member) => {
    onMemberUpdate(updatedMember);
    setIsEditOpen(false);
    setEditingMember(null);
  };

  return (
    <Card className="rounded-xl shadow-md">
      <CardHeader className="space-y-4">
        <div className="flex justify-between items-center">
          <CardTitle className="flex items-center gap-2 text-lg font-semibold text-foreground">
            Lista de Membros ({membersFiltradosPorLetra.length} registros) 
            {totalPages > 1 && (
              <span className="text-sm font-normal text-muted-foreground">
                - Página {currentPage} de {totalPages}
              </span>
            )}
          </CardTitle>
          <div className="flex gap-2">
            <Button variant="outline" size="sm" onClick={handleOpenPdfConfig}>
              <FileText className="h-4 w-4 mr-2" />
              Exportar para PDF
            </Button>
            <Button variant="outline" size="sm" onClick={() => setActiveNoAvatarOpen(true)}>
              {/* simple icon */}
              <svg className="h-4 w-4 mr-2" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zM11 6h2v6h-2V6zm0 8h2v2h-2v-2z" fill="currentColor"/></svg>
              Ativos sem avatar
            </Button>
            <Button variant="outline" size="sm" onClick={onRefresh}>
              <RefreshCw className="h-4 w-4 mr-2" />
              Atualizar Lista
            </Button>
          </div>
        </div>
        <ActiveNoAvatarModal open={activeNoAvatarOpen} onOpenChange={setActiveNoAvatarOpen} />

        <div className="flex flex-wrap items-center gap-1 bg-muted/40 p-2 rounded-lg border">
          <Button
            variant={selectedLetter === null ? "default" : "ghost"}
            size="sm"
            className="h-8 px-3 text-xs font-bold rounded-md"
            onClick={() => handleLetterSelect(null)}
          >
            TODOS
          </Button>
          <div className="h-4 w-px bg-border mx-1" />
          <div className="flex flex-wrap gap-1 flex-1">
            {alfabeto.map(letter => {
              const possuiMembros = letrasAtivas.has(letter);
              return (
                <Button
                  key={letter}
                  variant={selectedLetter === letter ? "default" : "ghost"}
                  size="icon"
                  className={`h-8 w-8 text-xs font-semibold rounded-md ${
                    !possuiMembros && selectedLetter !== letter ? 'opacity-35' : ''
                  }`}
                  onClick={() => handleLetterSelect(letter)}
                >
                  {letter}
                </Button>
              );
            })}
          </div>
        </div>
      </CardHeader>
      
      <CardContent>
        <div className="overflow-x-auto">
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead className="w-12"></TableHead>
                <TableHead className="cursor-pointer" onClick={() => onSort('nome')}>
                  <div className="flex items-center gap-1">Nome {getSortIcon('nome')}</div>
                </TableHead>
                <TableHead className="cursor-pointer" onClick={() => onSort('dataNascimento')}>
                  <div className="flex items-center gap-1">Data de Nascimento {getSortIcon('dataNascimento')}</div>
                </TableHead>
                <TableHead className="cursor-pointer" onClick={() => onSort('idade')}>
                  <div className="flex items-center gap-1">Idade {getSortIcon('idade')}</div>
                </TableHead>
                <TableHead className="cursor-pointer" onClick={() => onSort('tipo')}>
                  <div className="flex items-center gap-1">Tipo {getSortIcon('tipo')}</div>
                </TableHead>
                <TableHead className="cursor-pointer" onClick={() => onSort('status')}>
                  <div className="flex items-center gap-1">Status {getSortIcon('status')}</div>
                </TableHead>
                <TableHead className="text-right">Ações</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {paginatedMembers.map(member => (
                <TableRow key={member.id}>
                  <TableCell className="w-16">
                    <div className="flex items-center justify-center">
                      {member.avatar_url ? (
                        <img
                          src={member.avatar_url}
                          alt={member.nome}
                          className="w-12 h-12 aspect-square rounded-full object-cover object-center shadow-sm border border-gray-200"
                          style={{ width: '48px', height: '48px', minWidth: '48px', minHeight: '48px', maxWidth: '48px', maxHeight: '48px' }}
                          onError={(e) => {
                            e.currentTarget.style.display = 'none';
                            e.currentTarget.nextElementSibling?.classList.remove('hidden');
                          }}
                        />
                      ) : null}
                      <div 
                        className={`w-12 h-12 aspect-square rounded-full bg-gradient-to-br from-blue-400 to-blue-600 flex items-center justify-center text-white shadow-sm ${member.avatar_url ? 'hidden' : ''}`}
                        style={{ width: '48px', height: '48px', minWidth: '48px', minHeight: '48px', maxWidth: '48px', maxHeight: '48px' }}
                      >
                        <span className="text-lg font-bold">
                          {member.nome?.charAt(0)?.toUpperCase() || '?'}
                        </span>
                      </div>
                    </div>
                  </TableCell>
                  <TableCell className="font-medium">
                    {(member.nomeCompleto || member.nome || 'N/A').toUpperCase()}
                  </TableCell>
                  <TableCell>
                    {member.dataNascimento ? (() => {
                      const date = new Date(member.dataNascimento);
                      return isNaN(date.getTime()) ? 'N/A' : date.toLocaleDateString('pt-BR');
                    })() : 'N/A'}
                  </TableCell>
                  <TableCell>{calculateAge(member.dataNascimento)} anos</TableCell>
                  <TableCell><MemberTypeBadge type={getMemberType(member)} /></TableCell>
                  <TableCell>
                    <Badge variant={member.status === 'ativo' ? 'default' : 'secondary'}>
                      {member.status === 'ativo' ? 'Ativo' : 'Desligado'}
                    </Badge>
                  </TableCell>
                  <TableCell className="text-right">
                    <Button variant="ghost" size="icon" onClick={() => handleViewDetails(member)}><Eye className="h-4 w-4" /></Button>
                    <Button variant="ghost" size="icon" onClick={() => handleEditClick(member)}><Edit className="h-4 w-4" /></Button>
                  </TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
        </div>
        
        {totalPages > 1 && (
          <div className="flex items-center justify-between px-2 py-4 border-t">
            <div className="text-sm text-muted-foreground">
              Mostrando {((currentPage - 1) * ITEMS_PER_PAGE) + 1} a {Math.min(currentPage * ITEMS_PER_PAGE, membersFiltradosPorLetra.length)} de {membersFiltradosPorLetra.length} registros
            </div>
            <div className="flex items-center gap-2">
              <Button
                variant="outline"
                size="sm"
                onClick={() => setCurrentPage(1)}
                disabled={currentPage === 1}
              >
                <ChevronsLeft className="h-4 w-4" />
              </Button>
              <Button
                variant="outline"
                size="sm"
                onClick={() => setCurrentPage(prev => Math.max(1, prev - 1))}
                disabled={currentPage === 1}
              >
                <ChevronLeft className="h-4 w-4" />
              </Button>
              
              <div className="flex items-center gap-1">
                {Array.from({ length: Math.min(5, totalPages) }, (_, i) => {
                  let pageNum;
                  if (totalPages <= 5) {
                    pageNum = i + 1;
                  } else if (currentPage <= 3) {
                    pageNum = i + 1;
                  } else if (currentPage >= totalPages - 2) {
                    pageNum = totalPages - 4 + i;
                  } else {
                    pageNum = currentPage - 2 + i;
                  }
                  
                  return (
                    <Button
                      key={pageNum}
                      variant={currentPage === pageNum ? "default" : "outline"}
                      size="sm"
                      onClick={() => setCurrentPage(pageNum)}
                      className="w-10"
                    >
                      {pageNum}
                    </Button>
                  );
                })}
              </div>

              <Button
                variant="outline"
                size="sm"
                onClick={() => setCurrentPage(prev => Math.min(totalPages, prev + 1))}
                disabled={currentPage === totalPages}
              >
                <ChevronRight className="h-4 w-4" />
              </Button>
              <Button
                variant="outline"
                size="sm"
                onClick={() => setCurrentPage(totalPages)}
                disabled={currentPage === totalPages}
              >
                <ChevronsRight className="h-4 w-4" />
              </Button>
            </div>
          </div>
        )}
        
        {membersFiltradosPorLetra.length === 0 && (
          <div className="text-center py-8 text-muted-foreground">
            Nenhum membro encontrado com a letra inicial selecionada ou filtros aplicados.
          </div>
        )}
        
        <Dialog open={isDetailsOpen} onOpenChange={setIsDetailsOpen}>
          <DialogContent className="max-w-3xl">
            <DialogHeader><DialogTitle>Detalhes do Membro</DialogTitle></DialogHeader>
            {selectedMember && <MemberDetails member={selectedMember} onMemberUpdate={onMemberUpdate} />}
          </DialogContent>
        </Dialog>
        
        <MemberEdit member={editingMember} isOpen={isEditOpen} onClose={() => setEditingMember(null)} onSave={handleSaveEdit} />
        
        <Dialog open={isPdfConfigOpen} onOpenChange={setIsPdfConfigOpen}>
          <DialogContent className="sm:max-w-[425px]">
            <DialogHeader>
              <DialogTitle>Configurações de Exportação PDF</DialogTitle>
            </DialogHeader>
            <div className="space-y-4 py-4">
              <div className="flex items-center space-x-2">
                <Checkbox id="show-age" checked={showAge} onCheckedChange={(checked) => setShowAge(!!checked)} />
                <Label htmlFor="show-age" className="cursor-pointer">Incluir coluna de Idade</Label>
              </div>
              <div className="flex items-center space-x-2">
                <Checkbox id="show-photo" checked={showPhoto} onCheckedChange={(checked) => setShowPhoto(!!checked)} />
                <Label htmlFor="show-photo" className="cursor-pointer">Incluir fotos dos membros</Label>
              </div>
              <div className="flex items-center space-x-2">
                <Checkbox id="show-birthday-weekday" checked={showBirthdayWeekday} onCheckedChange={(checked) => setShowBirthdayWeekday(!!checked)} />
                <Label htmlFor="show-birthday-weekday" className="cursor-pointer">Incluir próximo aniversário (dia da semana)</Label>
              </div>
              <div className="flex items-center space-x-2">
                <Checkbox id="show-type" checked={showType} onCheckedChange={(checked) => setShowType(!!checked)} />
                <Label htmlFor="show-type" className="cursor-pointer">Incluir tipo de membro</Label>
              </div>
              <div className="text-sm text-muted-foreground border-t pt-3">
                <p>📊 Total de registros filtrados: <strong>{membersFiltradosPorLetra.length}</strong></p>
                <p>📄 A ordenação e o filtro alfabético atuais serão mantidos no PDF</p>
              </div>
            </div>
            <DialogFooter>
              <Button variant="outline" onClick={() => setIsPdfConfigOpen(false)}>Cancelar</Button>
              <Button onClick={handleExportPDF}><FileText className="h-4 w-4 mr-2" />Exportar PDF</Button>
            </DialogFooter>
          </DialogContent>
        </Dialog>
      </CardContent>
    </Card>
  );
};