// Local do arquivo: components/dashboard/MemberEdit.tsx
// ✅ CÓDIGO CORRIGIDO - Adicionado travamento de página única no style de impressão

import { useEffect, useState } from 'react';
import { Member } from '@/types/member';
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { z } from 'zod';
import { memberSchema } from '@/lib/validations/member';
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter } from '@/components/ui/dialog';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select';
import { Switch } from '@/components/ui/switch';
import { User, Printer, CreditCard } from 'lucide-react';
import { useToast } from '@/hooks/use-toast';
import { Form, FormControl, FormField, FormItem, FormLabel, FormMessage } from '@/components/ui/form';
import { AvatarCropDialog } from '@/components/ui/AvatarCropDialog';
import { MemberRegistrationForm } from './MemberRegistrationForm';
import { createRoot } from 'react-dom/client';
import { generateMemberCard } from '@/utils/cardGenerator';

interface MemberEditProps {
  member: Member | null;
  isOpen: boolean;
  onClose: () => void;
  onSave: (member: Member) => void;
}

type MemberFormData = z.infer<typeof memberSchema>;

const formatPhone = (phone: string | undefined): string => {
  if (!phone) return '';
  const numbers = phone.replace(/\D/g, '');
  if (numbers.length === 11) {
    return `(${numbers.slice(0, 2)}) ${numbers.slice(2, 3)} ${numbers.slice(3, 7)}-${numbers.slice(7)}`;
  } else if (numbers.length === 10) {
    return `(${numbers.slice(0, 2)}) ${numbers.slice(2, 6)}-${numbers.slice(6)}`;
  }
  return phone;
};

const formatCEP = (cep: string | undefined): string => {
  if (!cep) return '';
  const numbers = cep.replace(/\D/g, '');
  if (numbers.length === 8) {
    return `${numbers.slice(0, 2)}.${numbers.slice(2, 5)}-${numbers.slice(5)}`;
  }
  return cep;
};

const formatDateForInput = (dateString: string | undefined): string => {
  if (!dateString) return '';
  try {
    if (/^\d{4}-\d{2}-\d{2}$/.test(dateString)) {
      return dateString;
    }
    const date = new Date(dateString);
    if (!isNaN(date.getTime())) {
      const year = date.getFullYear();
      const month = String(date.getMonth() + 1).padStart(2, '0');
      const day = String(date.getDate()).padStart(2, '0');
      return `${year}-${month}-${day}`;
    }
  } catch (e) {
    console.error('Erro ao formatar data:', e);
  }
  return '';
};

export function MemberEdit({ member, isOpen, onClose, onSave }: MemberEditProps) {
  const { toast } = useToast();
  const [isCropDialogOpen, setIsCropDialogOpen] = useState(false);
  const [selectedImageFile, setSelectedImageFile] = useState<File | null>(null);

  const form = useForm<MemberFormData>({
    resolver: zodResolver(memberSchema),
    defaultValues: member || {},
  });

  useEffect(() => {
    if (member) {
      const memberWithFormattedData = {
        ...member,
        telefone: formatPhone(member.telefone),
        cep: formatCEP(member.cep),
        dataNascimento: formatDateForInput(member.dataNascimento)
      };
      form.reset(memberWithFormattedData);
    }
  }, [member, form]);

  if (!member) return null;

  const handleSave = async (data: MemberFormData) => {
    try {
      const phoneNumbers = data.telefone?.replace(/\D/g, '') || '';
      const cepNumbers = data.cep?.replace(/\D/g, '') || '';
      
      let avatarUrl = data.avatar_url;
      if (avatarUrl?.includes('http://localhost:5001')) {
        avatarUrl = avatarUrl.replace('http://localhost:5001', '');
      }
      
      const updatedMember = {
        ...member,
        ...data,
        telefone: phoneNumbers,
        cep: cepNumbers,
        avatar_url: avatarUrl,
        updatedAt: new Date().toISOString(),
      };
      
      const response = await fetch(`http://localhost:5001/api/members/${member.id}`, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          nome_completo: updatedMember.nomeCompleto,
          data_nascimento: updatedMember.dataNascimento,
          telefone: updatedMember.telefone,
          rua: updatedMember.endereco,
          bairro: updatedMember.bairro,
          cidade: updatedMember.cidade,
          cep: updatedMember.cep,
          status_civil: updatedMember.statusCivil,
          observacoes: updatedMember.observacoes,
          avatar_url: updatedMember.avatar_url,
        }),
      });

      if (!response.ok) {
        throw new Error('Erro ao atualizar membro');
      }

      onSave(updatedMember);
      toast({
        title: "Membro updated",
        description: "Os dados do membro foram atualizados com sucesso."
      });
      onClose();
    } catch (error) {
      console.error('Erro ao salvar:', error);
      toast({
        title: "Erro ao atualizar",
        description: "Não foi possível atualizar o membro. Tente novamente.",
        variant: "destructive"
      });
    }
  };

  const handleCropComplete = async (croppedImageBlob: Blob) => {
    try {
      console.log('📸 Imagem cortada recebida:', croppedImageBlob.size, 'bytes');
      const formData = new FormData();
      formData.append('avatar', croppedImageBlob, 'avatar.jpg');
      formData.append('memberId', member!.id.toString());
      
      console.log('🔄 Enviando avatar para o servidor...');
      const res = await fetch('http://localhost:5001/api/upload-avatar', {
        method: 'POST',
        body: formData,
      });
      
      if (!res.ok) {
        const errorData = await res.json().catch(() => ({}));
        throw new Error(errorData.message || `Erro HTTP: ${res.status}`);
      }
      
      const data = await res.json();
      console.log('✅ Avatar enviado:', data);
      
      if (data.avatar_url) {
        const fullUrl = `http://localhost:5001${data.avatar_url}`;
        form.setValue('avatar_url', fullUrl);
        console.log('✅ Avatar URL atualizado no formulário:', fullUrl);
        
        toast({
          title: "Avatar atualizado!",
          description: "A foto foi salva com sucesso.",
        });
      }
    } catch (err) {
      console.error('❌ Erro ao fazer upload do avatar:', err);
      toast({
        title: "Erro ao fazer upload",
        description: err instanceof Error ? err.message : "Erro desconhecido. Verifique o console.",
        variant: "destructive"
      });
    }
  };
  
  const status = form.watch('status');
  const isMembro = form.watch('membro');
  const isDesligado = status === 'desligado';

  const handlePrintForm = () => {
    const printWindow = window.open('', '_blank');
    if (!printWindow) {
      toast({
        title: "Erro ao abrir janela",
        description: "Por favor, permita pop-ups para imprimir a ficha.",
        variant: "destructive"
      });
      return;
    }

    const currentMember = form.getValues();
    const memberData: Member = {
      ...member,
      ...currentMember
    };

    printWindow.document.write(`
      <!DOCTYPE html>
      <html lang="pt-BR">
      <head>
        <meta charset="UTF-8">
        <title>Preview - Ficha de Cadastro - ${memberData.nome}</title>
        <style>
          * {
            -webkit-print-color-adjust: exact !important;
            print-color-adjust: exact !important;
            color-adjust: exact !important;
          }
          body { 
            margin: 0; 
            padding: 20px; 
            font-family: Arial, sans-serif;
            background: #f5f5f5;
          }
          @media print {
            html, body {
              height: 100% !important;
              overflow: hidden !important; /* 👈 TRAVA A EMISSÃO DO IMPRESSOR EM PÁGINA ÚNICA */
            }
            body { 
              padding: 0;
              background: white !important;
              margin: 0;
            }
            .print-controls { 
              display: none !important; 
            }
            @page {
              margin: 0;
              size: A4 portrait;
            }
          }
          .print-controls {
            position: fixed;
            top: 20px;
            right: 20px;
            display: flex;
            gap: 10px;
            z-index: 9999;
          }
          .print-button, .close-button {
            padding: 12px 24px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 14px;
            font-weight: bold;
            box-shadow: 0 2px 8px rgba(0,0,0,0.2);
            transition: all 0.2s;
          }
          .print-button {
            background: #10b981;
            color: white;
          }
          .print-button:hover {
            background: #059669;
          }
          .close-button {
            background: #ef4444;
            color: white;
          }
          .close-button:hover {
            background: #dc2626;
          }
        </style>
      </head>
      <body>
        <div class="print-controls">
          <button class="close-button" onclick="window.close()">✖ Fechar</button>
          <button class="print-button" onclick="window.print()">🖨️ Imprimir</button>
        </div>
        <div id="root"></div>
      </body>
      </html>
    `);
    
    printWindow.document.close();

    setTimeout(() => {
      const container = printWindow.document.getElementById('root');
      if (container) {
        const root = createRoot(container);
        root.render(<MemberRegistrationForm member={memberData} />);
      }
    }, 100);
  };

  const handlePrintCard = async () => {
    try {
      const currentMember = form.getValues();
      const memberData: Member = {
        ...member,
        ...currentMember
      };

      const cardData = {
        nome: memberData.nomeCompleto || memberData.nome || '',
        id: memberData.id || '',
        telefone: memberData.telefone,
        Igreja: 'IGREJA BATISTA EM VILA PALESTINA',
        avatar_url: memberData.avatarUrl
      };

      toast({
        title: "Gerando carteirinha...",
        description: "Processando PDF da carteirinha de membro.",
      });

      const pdfBytes = await generateMemberCard(cardData);
      const blob = new Blob([pdfBytes], { type: 'application/pdf' });
      const url = URL.createObjectURL(blob);
      
      const link = document.createElement('a');
      link.href = url;
      link.download = `carteirinha-${memberData.id || memberData.nome}.pdf`;
      document.body.appendChild(link);
      link.click();
      document.body.removeChild(link);
      URL.revokeObjectURL(url);

      toast({
        title: "Sucesso!",
        description: "Carteirinha gerada e baixada com sucesso.",
      });
    } catch (error) {
      console.error('Erro ao gerar carteirinha:', error);
      toast({
        title: "Erro ao gerar carteirinha",
        description: error instanceof Error ? error.message : "Erro desconhecido",
        variant: "destructive"
      });
    }
  };

  return (
    <Dialog open={isOpen} onOpenChange={onClose}>
      <DialogContent className="max-w-2xl max-h-[80vh] overflow-y-auto rounded-xl shadow-md">
        <DialogHeader>
          <DialogTitle>Editar Membro</DialogTitle>
        </DialogHeader>
        <Form {...form}>
          <form onSubmit={form.handleSubmit(handleSave)} className="grid grid-cols-1 md:grid-cols-2 gap-4 py-4">

            <FormField
              control={form.control}
              name="avatar_url"
              render={({ field }) => (
                <FormItem>
                  <FormLabel>Foto/Avatar</FormLabel>
                  <FormControl>
                    <div className="flex items-center gap-2">
                      <label htmlFor="avatar-upload" className="cursor-pointer">
                        {typeof field.value === 'string' && field.value ? (
                          <img
                            src={field.value}
                            alt="Avatar"
                            className="w-16 h-16 aspect-square rounded-full object-cover object-center border"
                          />
                        ) : (
                          <div className="w-16 h-16 aspect-square rounded-full bg-gray-200 flex items-center justify-center text-gray-400 border">
                            <span className="text-xs">Selecionar</span>
                          </div>
                        )}
                      </label>
                      <input
                        id="avatar-upload"
                        type="file"
                        accept="image/*"
                        style={{ display: 'none' }}
                        onChange={(e) => {
                          const file = e.target.files?.[0];
                          if (!file) return;
                          console.log('📸 Arquivo selecionado:', file.name);
                          setSelectedImageFile(file);
                          setIsCropDialogOpen(true);
                          e.target.value = '';
                        }}
                      />
                    </div>
                  </FormControl>
                  <FormMessage />
                </FormItem>
              )}
            />
            
            <FormField
              control={form.control}
              name="nome"
              render={({ field }) => (
                <FormItem>
                  <FormLabel>Nome</FormLabel>
                  <FormControl><Input {...field} /></FormControl>
                  <FormMessage />
                </FormItem>
              )}
            />
            
            <FormField
              control={form.control}
              name="nomeCompleto"
              render={({ field }) => (
                <FormItem>
                  <FormLabel>Nome Completo</FormLabel>
                  <FormControl><Input {...field} value={field.value ?? ''} /></FormControl>
                  <FormMessage />
                </FormItem>
              )}
            />

            <FormField
              control={form.control}
              name="dataNascimento"
              render={({ field }) => (
                <FormItem>
                  <FormLabel>Data de Nascimento</FormLabel>
                  <FormControl><Input type="date" {...field} value={field.value ?? ''} /></FormControl>
                  <FormMessage />
                </FormItem>
              )}
            />

            <FormField
              control={form.control}
              name="sexo"
              render={({ field }) => (
                <FormItem>
                  <FormLabel>Sexo</FormLabel>
                  <Select onValueChange={field.onChange} value={field.value}>
                    <FormControl><SelectTrigger><SelectValue /></SelectTrigger></FormControl>
                    <SelectContent>
                      <SelectItem value="M">Masculino</SelectItem>
                      <SelectItem value="F">Feminino</SelectItem>
                    </SelectContent>
                  </Select>
                  <FormMessage />
                </FormItem>
              )}
            />

            <FormField 
              control={form.control} 
              name="telefone" 
              render={({ field }) => (
                <FormItem>
                  <FormLabel>Telefone</FormLabel>
                  <FormControl>
                    <Input 
                      {...field} 
                      value={field.value ?? ''} 
                      placeholder="(27) 9 9999-9999"
                      onChange={(e) => {
                        let value = e.target.value.replace(/\D/g, '');
                        if (value.length > 11) value = value.slice(0, 11);
                        if (value.length > 6) {
                          value = `(${value.slice(0, 2)}) ${value.slice(2, 3)} ${value.slice(3, 7)}-${value.slice(7)}`;
                        } else if (value.length > 2) {
                          value = `(${value.slice(0, 2)}) ${value.slice(2)}`;
                        } else if (value.length > 0) {
                          value = `(${value}`;
                        }
                        field.onChange(value);
                      }}
                    />
                  </FormControl>
                  <FormMessage />
                </FormItem>
              )} 
            />
            <FormField control={form.control} name="email" render={({ field }) => (<FormItem><FormLabel>Email</FormLabel><FormControl><Input {...field} value={field.value ?? ''} /></FormControl><FormMessage /></FormItem>)} />
            <FormField control={form.control} name="endereco" render={({ field }) => (<FormItem><FormLabel>Endereço</FormLabel><FormControl><Input {...field} value={field.value ?? ''} /></FormControl><FormMessage /></FormItem>)} />
            <FormField control={form.control} name="bairro" render={({ field }) => (<FormItem><FormLabel>Bairro</FormLabel><FormControl><Input {...field} value={field.value ?? ''} /></FormControl><FormMessage /></FormItem>)} />
            <FormField control={form.control} name="cidade" render={({ field }) => (<FormItem><FormLabel>Cidade</FormLabel><FormControl><Input {...field} value={field.value ?? ''} /></FormControl><FormMessage /></FormItem>)} />
            <FormField control={form.control} name="cep" render={({ field }) => (
              <FormItem>
                <FormLabel>CEP</FormLabel>
                <FormControl>
                  <Input 
                    {...field} 
                    value={field.value ?? ''} 
                    onChange={(e) => {
                      const value = e.target.value.replace(/\D/g, '');
                      let formatted = value;
                      if (value.length >= 5) {
                        formatted = `${value.slice(0, 2)}.${value.slice(2, 5)}`;
                        if (value.length > 5) {
                          formatted += `-${value.slice(5, 8)}`;
                        }
                      }
                      field.onChange(formatted);
                    }}
                  />
                </FormControl>
                <FormMessage />
              </FormItem>
            )} />

             <FormField
              control={form.control}
              name="status"
              render={({ field }) => (
                <FormItem>
                  <FormLabel>Status</FormLabel>
                    <Select onValueChange={field.onChange} value={field.value}>
                      <FormControl><SelectTrigger><SelectValue placeholder="Selecione o status" /></SelectTrigger></FormControl>
                      <SelectContent>
                        <SelectItem value="ativo">Ativo</SelectItem>
                        <SelectItem value="desligado">Desligado</SelectItem>
                      </SelectContent>
                    </Select>
                  <FormMessage />
                </FormItem>
              )}
            />
            
            <FormField control={form.control} name="statusCivil" render={({ field }) => (<FormItem><FormLabel>Status Civil</FormLabel><FormControl><Input {...field} value={field.value ?? ''} /></FormControl><FormMessage /></FormItem>)} />
            
            <div className="md:col-span-2">
                <FormField control={form.control} name="observacoes" render={({ field }) => (<FormItem><FormLabel>Observações</FormLabel><FormControl><Input {...field} value={field.value ?? ''} placeholder="Digite observações..." /></FormControl><FormMessage /></FormItem>)} />
            </div>

            {!isDesligado && (
              <>
                <FormField
                  control={form.control}
                  name="membro"
                  render={({ field }) => (
                    <FormItem className="flex flex-row items-center justify-between rounded-lg border p-3 shadow-sm">
                      <div className="space-y-0.5"><FormLabel>Membro</FormLabel></div>
                      <FormControl><Switch checked={field.value} onCheckedChange={field.onChange} /></FormControl>
                    </FormItem>
                  )}
                />
                 <FormField
                  control={form.control}
                  name="batizado"
                  render={({ field }) => (
                    <FormItem className="flex flex-row items-center justify-between rounded-lg border p-3 shadow-sm">
                      <div className="space-y-0.5"><FormLabel>Batizado</FormLabel></div>
                      <FormControl><Switch checked={field.value} onCheckedChange={field.onChange} disabled={!isMembro} /></FormControl>
                    </FormItem>
                  )}
                />
                <FormField
                  control={form.control}
                  name="lider"
                  render={({ field }) => (
                    <FormItem className="flex flex-row items-center justify-between rounded-lg border p-3 shadow-sm">
                      <div className="space-y-0.5"><FormLabel>Líder</FormLabel></div>
                      <FormControl><Switch checked={field.value} onCheckedChange={field.onChange} /></FormControl>
                    </FormItem>
                  )}
                />
                <FormField
                  control={form.control}
                  name="professorEBQ"
                  render={({ field }) => (
                    <FormItem className="flex flex-row items-center justify-between rounded-lg border p-3 shadow-sm">
                      <div className="space-y-0.5"><FormLabel>Professor EBQ</FormLabel></div>
                      <FormControl><Switch checked={field.value} onCheckedChange={field.onChange} /></FormControl>
                    </FormItem>
                  )}
                />
              </>
            )}

            <DialogFooter className="md:col-span-2">
              <div className="flex justify-between w-full">
                <div className="flex gap-2">
                  <Button type="button" variant="outline" onClick={handlePrintForm} className="gap-2">
                    <Printer className="h-4 w-4" />
                    Imprimir Ficha
                  </Button>
                  <Button type="button" variant="outline" onClick={handlePrintCard} className="gap-2">
                    <CreditCard className="h-4 w-4" />
                    Imprimir Carteirinha
                  </Button>
                </div>
                <div className="flex gap-2">
                  <Button type="button" variant="outline" onClick={onClose}>Cancelar</Button>
                  <Button type="submit">Salvar Alterações</Button>
                </div>
              </div>
            </DialogFooter>
          </form>
        </Form>
      </DialogContent>
      
      <AvatarCropDialog
        isOpen={isCropDialogOpen}
        onClose={() => setIsCropDialogOpen(false)}
        imageFile={selectedImageFile}
        onCropComplete={handleCropComplete}
      />
    </Dialog>
  );
};