// Componente React para Sincronização com Google Sheets
import { useState } from 'react';
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { useToast } from '@/hooks/use-toast';
import { RefreshCw, Link2, CheckCircle2, XCircle, Globe, Clock } from 'lucide-react';
import axios from 'axios';

const API_URL = import.meta.env.VITE_API_URL || 'http://localhost:5001';

interface SyncResult {
  sucesso: boolean;
  total_processados?: number;
  importados?: number;
  atualizados?: number;
  timestamp?: string;
  erro?: string;
  mensagem?: string;
}

export const GoogleSheetsSync = () => {
  const { toast } = useToast();
  const [loading, setLoading] = useState(false);
  const [testing, setTesting] = useState(false);
  const [lastSync, setLastSync] = useState<SyncResult | null>(null);

  /**
   * Sincronização manual - chamada quando usuário clica no botão
   */
  const handleManualSync = async () => {
    setLoading(true);
    try {
      console.log('🔄 Iniciando sincronização manual com Google Sheets...');

      const response = await axios.post<SyncResult>(
        `${API_URL}/api/sync/google-sheets`,
        {},
        { timeout: 60000 } // 60 segundos de timeout
      );

      const resultado = response.data;
      setLastSync(resultado);

      if (resultado.sucesso) {
        toast({
          title: "✅ Sincronização Concluída!",
          description: `${resultado.importados || 0} membros importados com sucesso`,
          duration: 5000,
        });

        // Não recarregar a página, pois isso causa 404 em rotas SPA como /importacao
        setLastSync(resultado);
      } else {
        throw new Error(resultado.mensagem || 'Erro desconhecido');
      }

    } catch (error) {
      console.error('❌ Erro na sincronização:', error);
      
      const errorMessage = axios.isAxiosError(error)
        ? error.response?.data?.mensagem || error.message
        : 'Erro ao conectar com o servidor';

      toast({
        title: "❌ Erro na Sincronização",
        description: errorMessage,
        variant: "destructive",
        duration: 7000,
      });

      setLastSync({
        sucesso: false,
        erro: errorMessage
      });
    } finally {
      setLoading(false);
    }
  };

  /**
   * Testa conexão sem importar
   */
  const handleTestConnection = async () => {
    setTesting(true);
    try {
      console.log('🧪 Testando conexão com Google Sheets...');

      const response = await axios.get(
        `${API_URL}/api/sync/google-sheets/test`,
        { timeout: 30000 }
      );

      const resultado = response.data;

      if (resultado.sucesso) {
        toast({
          title: "✅ Conexão OK!",
          description: `${resultado.total_registros} registros encontrados na planilha`,
          duration: 5000,
        });
      } else {
        throw new Error(resultado.mensagem || 'Erro no teste');
      }

    } catch (error) {
      console.error('❌ Erro no teste:', error);
      
      const errorMessage = axios.isAxiosError(error)
        ? error.response?.data?.mensagem || error.message
        : 'Erro ao conectar com o servidor';

      toast({
        title: "❌ Falha no Teste",
        description: errorMessage,
        variant: "destructive",
        duration: 7000,
      });
    } finally {
      setTesting(false);
    }
  };

  return (
    <Card className="w-full">
      <CardHeader>
        <CardTitle className="flex items-center gap-2">
          <Globe className="h-5 w-5 text-green-600" />
          Sincronização Google Sheets
          <span className="ml-auto text-xs bg-primary/10 text-primary-foreground px-2 py-1 rounded-full font-medium">
            Webhook ativo ⚡
          </span>
        </CardTitle>
        <CardDescription>
          Sincronize automaticamente com a planilha do Google Sheets. 
          Os dados são atualizados em tempo real via webhook.
        </CardDescription>
      </CardHeader>
      <CardContent className="space-y-6">
        {/* Status da última sincronização */}
        {lastSync ? (
          <div className={`p-4 rounded-lg border ${
            lastSync.sucesso 
              ? 'bg-success/10 border-success/20' 
              : 'bg-destructive/10 border-destructive/20'
          }`} aria-live="polite">
            <div className="flex items-start gap-3">
              {lastSync.sucesso ? (
                <CheckCircle2 className="h-5 w-5 text-success-foreground mt-0.5" />
              ) : (
                <XCircle className="h-5 w-5 text-destructive-foreground mt-0.5" />
              )}
              <div className="flex-1">
                <p className={`font-medium ${
                  lastSync.sucesso ? 'text-success-foreground' : 'text-destructive-foreground'
                }`}>
                  {lastSync.sucesso ? 'Última sincronização bem-sucedida' : 'Erro na sincronização'}
                </p>
                <div className="mt-3 grid gap-2 sm:grid-cols-3">
                  {lastSync.importados != null && (
                    <div className="rounded-md bg-card p-3 border border-border text-sm text-card-foreground">
                      <div className="font-semibold text-foreground">Importados</div>
                      <div>{lastSync.importados}</div>
                    </div>
                  )}
                  {lastSync.atualizados != null && (
                    <div className="rounded-md bg-card p-3 border border-border text-sm text-card-foreground">
                      <div className="font-semibold text-foreground">Atualizados</div>
                      <div>{lastSync.atualizados}</div>
                    </div>
                  )}
                  {lastSync.total_processados != null && (
                    <div className="rounded-md bg-card p-3 border border-border text-sm text-card-foreground">
                      <div className="font-semibold text-foreground">Processados</div>
                      <div>{lastSync.total_processados}</div>
                    </div>
                  )}
                </div>
                {lastSync.mensagem && (
                  <p className="text-sm text-muted-foreground mt-3">{lastSync.mensagem}</p>
                )}
                {lastSync.erro && (
                  <p className="text-sm text-destructive-foreground mt-3">{lastSync.erro}</p>
                )}
                {lastSync.timestamp && (
                  <p className="text-xs text-muted-foreground mt-3 flex items-center gap-1">
                    <Clock className="h-3 w-3" />
                    {new Date(lastSync.timestamp).toLocaleString('pt-BR')}
                  </p>
                )}
              </div>
            </div>
          </div>
        ) : (
          <div className="rounded-lg border border-border bg-muted p-4 text-sm text-muted-foreground">
            Nenhuma sincronização manual registrada ainda. O webhook automático mantém a planilha atualizada.
          </div>
        )}

        {/* Botões de ação */}
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          <Button 
            size="lg" 
            onClick={handleManualSync}
            disabled={loading || testing}
            className="w-full"
          >
            {loading ? (
              <>
                <RefreshCw className="h-4 w-4 mr-2 animate-spin" />
                Sincronizando...
              </>
            ) : (
              <>
                <RefreshCw className="h-4 w-4 mr-2" />
                Sincronizar Agora
              </>
            )}
          </Button>

          <Button 
            size="lg" 
            variant="outline"
            onClick={handleTestConnection}
            disabled={loading || testing}
            className="w-full"
          >
            {testing ? (
              <>
                <RefreshCw className="h-4 w-4 mr-2 animate-spin" />
                Testando...
              </>
            ) : (
              <>
                <Link2 className="h-4 w-4 mr-2" />
                Testar Conexão
              </>
            )}
          </Button>
        </div>

        {/* Informações adicionais */}
        <div className="bg-muted rounded-lg p-4 border border-border">
          <h4 className="font-medium text-foreground mb-2">ℹ️ Como funciona:</h4>
          <ul className="text-sm text-muted-foreground space-y-1 list-disc list-inside">
            <li>Webhook automático notifica o sistema quando a planilha é editada</li>
            <li>Dados são sincronizados automaticamente em tempo real</li>
            <li>Você também pode sincronizar manualmente a qualquer momento</li>
            <li>Substituição completa - dados antigos são atualizados</li>
          </ul>
        </div>

        {/* Link da planilha */}
        <div className="text-xs text-muted-foreground p-3 bg-muted rounded border border-border">
          <strong>Planilha Configurada:</strong>
          <br />
          <a 
            href="https://docs.google.com/spreadsheets/d/e/2PACX-1vRdZMkpYxYB5uydpPPPhJWL0uPyBa44JOWzSyDQxcKof3mAbfvOCk2c9nZOiOFkRz7convCRILjtzuH/pubhtml?gid=2093457985&single=true"
            target="_blank"
            rel="noopener noreferrer"
            className="text-primary hover:underline break-all"
          >
            Abrir Google Sheets →
          </a>
        </div>
      </CardContent>
    </Card>
  );
};
