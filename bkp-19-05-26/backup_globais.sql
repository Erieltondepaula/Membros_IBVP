--
-- PostgreSQL database cluster dump
--

-- Started on 2026-05-19 13:26:45

\restrict 86SCmqQCYs9UJ5dMoNqXELdBhtCJvfVzPLd1D3hKiorLJNlrqnATWP9zxfTwQyY

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Roles
--

CREATE ROLE membros_user;
ALTER ROLE membros_user WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:Vvy6hpGbBXMlSLgZ6BfRpw==$d9MKggLHx+u05t+GkToq4wmPwmAuar6vywd8ByhSrbY=:38AWJdquONCiLHdoJ8knPaGvZD0lRh2KHht+IbnXVNE=';
CREATE ROLE postgres;
ALTER ROLE postgres WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:TvjPdWjDfPJAEx8VmLqMlg==$gIKZywVB3AMGuYWHWpq+KPTt+q4zK9BJbvXU7za23n0=:pU1hj/oE6fgNu5rS1yxaYBEAnTZkP68K64M6w1KeEAE=';

--
-- User Configurations
--








\unrestrict 86SCmqQCYs9UJ5dMoNqXELdBhtCJvfVzPLd1D3hKiorLJNlrqnATWP9zxfTwQyY

--
-- Databases
--

--
-- Database "template1" dump
--

\connect template1

--
-- PostgreSQL database dump
--

\restrict DkwH4eJXV89mazcOm8xPMdWyAw9o1cyj8H0MPa14YbnjAVBVrHl0bbkXylXNKdO

-- Dumped from database version 18.0
-- Dumped by pg_dump version 18.0

-- Started on 2026-05-19 13:26:46

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

-- Completed on 2026-05-19 13:26:46

--
-- PostgreSQL database dump complete
--

\unrestrict DkwH4eJXV89mazcOm8xPMdWyAw9o1cyj8H0MPa14YbnjAVBVrHl0bbkXylXNKdO

--
-- Database "dashboard_membros" dump
--

--
-- PostgreSQL database dump
--

\restrict tu0EofNZdPLsjbcUfxbNuc1n5z9wvCZDi3C97BZnrgLeKkkpCOeRX1Djff6PuTu

-- Dumped from database version 18.0
-- Dumped by pg_dump version 18.0

-- Started on 2026-05-19 13:26:46

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 5537 (class 1262 OID 16388)
-- Name: dashboard_membros; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE dashboard_membros WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Portuguese_Brazil.1252';


ALTER DATABASE dashboard_membros OWNER TO postgres;

\unrestrict tu0EofNZdPLsjbcUfxbNuc1n5z9wvCZDi3C97BZnrgLeKkkpCOeRX1Djff6PuTu
\connect dashboard_membros
\restrict tu0EofNZdPLsjbcUfxbNuc1n5z9wvCZDi3C97BZnrgLeKkkpCOeRX1Djff6PuTu

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 2 (class 3079 OID 17144)
-- Name: unaccent; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS unaccent WITH SCHEMA public;


--
-- TOC entry 5539 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION unaccent; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION unaccent IS 'text search dictionary that removes accents';


--
-- TOC entry 3 (class 3079 OID 17342)
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- TOC entry 5540 (class 0 OID 0)
-- Dependencies: 3
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- TOC entry 972 (class 1247 OID 17094)
-- Name: classificacao_vocal_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.classificacao_vocal_enum AS ENUM (
    'TENOR',
    'BARITONO',
    'BAIXO',
    'SOPRANO',
    'MEZZO_SOPRANO',
    'CONTRALTO'
);


ALTER TYPE public.classificacao_vocal_enum OWNER TO postgres;

--
-- TOC entry 975 (class 1247 OID 17109)
-- Name: tipo_membro_louvor_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.tipo_membro_louvor_enum AS ENUM (
    'LIDER',
    'INTEGRANTE'
);


ALTER TYPE public.tipo_membro_louvor_enum OWNER TO postgres;

--
-- TOC entry 306 (class 1255 OID 18048)
-- Name: atualizar_numerodomes(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.atualizar_numerodomes() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
      BEGIN
          IF NEW.data_nascimento IS NOT NULL THEN
              NEW.numerodomes = EXTRACT(MONTH FROM NEW.data_nascimento);
          END IF;
          RETURN NEW;
      END;
      $$;


ALTER FUNCTION public.atualizar_numerodomes() OWNER TO postgres;

--
-- TOC entry 317 (class 1255 OID 17716)
-- Name: auto_criar_escala_culto(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.auto_criar_escala_culto() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Só criar escala se o culto estiver planejado
    IF NEW.status = 'planejado' THEN
        PERFORM gerar_escala_para_culto(NEW.id);
    END IF;
    
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.auto_criar_escala_culto() OWNER TO postgres;

--
-- TOC entry 315 (class 1255 OID 17675)
-- Name: auto_gerar_codigo_instrumento(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.auto_gerar_codigo_instrumento() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Se código não foi informado ou está vazio
    IF NEW.codigo IS NULL OR NEW.codigo = '' THEN
        -- Gerar código baseado no nome do instrumento
        NEW.codigo := gerar_codigo_instrumento(NEW.nome);
    END IF;
    
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.auto_gerar_codigo_instrumento() OWNER TO postgres;

--
-- TOC entry 312 (class 1255 OID 17659)
-- Name: criar_evento_calendario_escala(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.criar_evento_calendario_escala() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Só cria evento se a escala for publicada
    IF NEW.publicada = true AND NEW.status != 'CANCELADA' THEN
        INSERT INTO calendario_louvor (
            titulo,
            descricao,
            data_inicio,
            data_fim,
            tipo,
            cor,
            escala_id,
            grupo_id,
            local,
            observacoes,
            criado_por
        ) VALUES (
            NEW.titulo,
            'Escala de louvor - ' || NEW.tipo_evento,
            NEW.data_evento,
            CASE 
                WHEN NEW.hora_fim IS NOT NULL THEN 
                    NEW.data_evento::date + NEW.hora_fim
                ELSE 
                    NEW.data_evento + INTERVAL '2 hours'
            END,
            'ESCALA',
            (SELECT cor FROM grupos_louvor WHERE id = NEW.grupo_id),
            NEW.id,
            NEW.grupo_id,
            NEW.local,
            NEW.observacoes,
            NEW.criado_por
        )
        ON CONFLICT DO NOTHING;
    END IF;
    
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.criar_evento_calendario_escala() OWNER TO postgres;

--
-- TOC entry 281 (class 1255 OID 16406)
-- Name: generate_member_id(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.generate_member_id(p_nome character varying, p_sobrenome character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
      DECLARE
        primeira_letra VARCHAR(1);
        segunda_letra VARCHAR(1);
        timestamp_str VARCHAR(14);
        new_id VARCHAR(20);
      BEGIN
        -- Primeira letra do nome (maiúscula)
        primeira_letra := UPPER(LEFT(TRIM(p_nome), 1));
        
        -- Segunda letra do sobrenome (maiúscula)
        segunda_letra := UPPER(LEFT(TRIM(p_sobrenome), 1));
        
        -- Timestamp no formato YYYYMMDDHHMMSS
        timestamp_str := TO_CHAR(NOW(), 'YYYYMMDDHH24MISS');
        
        -- Combinar: AA + YYYYMMDDHHMMSS
        new_id := primeira_letra || segunda_letra || timestamp_str;
        
        RETURN new_id;
      END;
      $$;


ALTER FUNCTION public.generate_member_id(p_nome character varying, p_sobrenome character varying) OWNER TO postgres;

--
-- TOC entry 308 (class 1255 OID 16426)
-- Name: generate_unique_member_id(character varying, character varying, date); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.generate_unique_member_id(p_nome character varying, p_sobrenome character varying, p_data_nascimento date) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
      DECLARE
        primeira_letra VARCHAR(1);
        segunda_letra VARCHAR(1);
        timestamp_str VARCHAR(14);
        seq_num INTEGER;
        new_id VARCHAR(20);
        final_id VARCHAR(20);
        counter INTEGER := 0;
      BEGIN
        -- Primeira letra do nome (maiúscula)
        primeira_letra := UPPER(LEFT(TRIM(p_nome), 1));
        
        -- Segunda letra do sobrenome (maiúscula)
        segunda_letra := UPPER(LEFT(TRIM(p_sobrenome), 1));
        
        -- Se sobrenome for igual ao nome, usar segunda letra do nome
        IF TRIM(p_sobrenome) = TRIM(p_nome) AND LENGTH(TRIM(p_nome)) > 1 THEN
          segunda_letra := UPPER(SUBSTRING(TRIM(p_nome), 2, 1));
        END IF;
        
        -- Timestamp no formato YYYYMMDDHHMMSS
        timestamp_str := TO_CHAR(NOW(), 'YYYYMMDDHH24MISS');
        
        -- Tentar gerar ID único
        LOOP
          -- Base do ID
          new_id := primeira_letra || segunda_letra || timestamp_str;
          
          -- Se não é primeira tentativa, adicionar sufixo
          IF counter > 0 THEN
            new_id := new_id || LPAD(counter::TEXT, 2, '0');
          END IF;
          
          -- Verificar se já existe
          SELECT COUNT(*) INTO seq_num FROM membros WHERE id = new_id;
          
          IF seq_num = 0 THEN
            final_id := new_id;
            EXIT;
          END IF;
          
          counter := counter + 1;
          
          -- Adicionar microsegundos se necessário
          IF counter > 99 THEN
            timestamp_str := TO_CHAR(NOW(), 'YYYYMMDDHH24MISSUS');
            counter := 0;
          END IF;
          
        END LOOP;
        
        RETURN final_id;
      END;
      $$;


ALTER FUNCTION public.generate_unique_member_id(p_nome character varying, p_sobrenome character varying, p_data_nascimento date) OWNER TO postgres;

--
-- TOC entry 314 (class 1255 OID 17674)
-- Name: gerar_codigo_instrumento(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.gerar_codigo_instrumento(p_tipo character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_prefixo VARCHAR(4);
    v_numero INTEGER;
    v_codigo VARCHAR(50);
BEGIN
    -- Definir prefixo baseado no tipo de instrumento
    v_prefixo := CASE 
        WHEN UPPER(p_tipo) LIKE '%GUITARRA%' OR UPPER(p_tipo) LIKE '%GUITAR%' THEN 'GUIT'
        WHEN UPPER(p_tipo) LIKE '%BAIXO%' OR UPPER(p_tipo) LIKE '%BASS%' THEN 'BAIX'
        WHEN UPPER(p_tipo) LIKE '%BATERIA%' OR UPPER(p_tipo) LIKE '%DRUM%' THEN 'BATE'
        WHEN UPPER(p_tipo) LIKE '%TECLADO%' OR UPPER(p_tipo) LIKE '%KEYBOARD%' THEN 'TECL'
        WHEN UPPER(p_tipo) LIKE '%VOZ%' OR UPPER(p_tipo) LIKE '%VOCAL%' OR UPPER(p_tipo) LIKE '%MICROFONE%' THEN 'VOZ'
        WHEN UPPER(p_tipo) LIKE '%VIOLÃO%' OR UPPER(p_tipo) LIKE '%VIOLAO%' THEN 'VIOL'
        WHEN UPPER(p_tipo) LIKE '%CAJON%' OR UPPER(p_tipo) LIKE '%CAJÓN%' THEN 'CAJO'
        WHEN UPPER(p_tipo) LIKE '%PANDEIRO%' THEN 'PAND'
        WHEN UPPER(p_tipo) LIKE '%SHAKER%' THEN 'SHAK'
        WHEN UPPER(p_tipo) LIKE '%AMPLIFICADOR%' OR UPPER(p_tipo) LIKE '%AMP%' THEN 'AMP'
        WHEN UPPER(p_tipo) LIKE '%CABO%' OR UPPER(p_tipo) LIKE '%CABLE%' THEN 'CABO'
        WHEN UPPER(p_tipo) LIKE '%PEDAL%' THEN 'PEDA'
        ELSE 'INST'
    END;
    
    -- Buscar próximo número disponível para este prefixo
    SELECT COALESCE(MAX(
        CAST(
            SUBSTRING(codigo FROM POSITION('-' IN codigo) + 1)
            AS INTEGER
        )
    ), 0) + 1
    INTO v_numero
    FROM instrumentos_inventario
    WHERE codigo LIKE v_prefixo || '-%';
    
    -- Gerar código formatado com 3 dígitos
    v_codigo := v_prefixo || '-' || LPAD(v_numero::TEXT, 3, '0');
    
    RETURN v_codigo;
END;
$$;


ALTER FUNCTION public.gerar_codigo_instrumento(p_tipo character varying) OWNER TO postgres;

--
-- TOC entry 5541 (class 0 OID 0)
-- Dependencies: 314
-- Name: FUNCTION gerar_codigo_instrumento(p_tipo character varying); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION public.gerar_codigo_instrumento(p_tipo character varying) IS 'Gera código automático para instrumentos baseado no tipo. Formato: TIPO-NNN';


--
-- TOC entry 309 (class 1255 OID 16434)
-- Name: gerar_codigo_referencia(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.gerar_codigo_referencia(p_nome_completo character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
DECLARE
    iniciais VARCHAR(3);
    timestamp_str VARCHAR(14);
    sufixo_aleatorio VARCHAR(4);
    codigo_final VARCHAR(30);
    contador INTEGER := 0;
BEGIN
    -- Extrair iniciais (até 3 caracteres para evitar overflow)
    SELECT LEFT(STRING_AGG(UPPER(LEFT(palavra, 1)), ''), 3)
    INTO iniciais
    FROM (
        SELECT UNNEST(STRING_TO_ARRAY(TRIM(p_nome_completo), ' ')) AS palavra
    ) AS palavras
    LIMIT 3;
    
    -- Se não conseguir iniciais, usar 'XX'
    IF iniciais IS NULL OR LENGTH(iniciais) = 0 THEN
        iniciais := 'XX';
    END IF;
    
    LOOP
        -- Timestamp atual
        timestamp_str := TO_CHAR(NOW(), 'YYYYMMDDHH24MISS');
        
        -- Sufixo aleatório (4 caracteres alfanuméricos)
        sufixo_aleatorio := UPPER(
            CHR(65 + (RANDOM() * 25)::INT) ||
            CHR(65 + (RANDOM() * 25)::INT) ||
            (RANDOM() * 9)::INT ||
            CHR(65 + (RANDOM() * 25)::INT)
        );
        
        -- Montar código final
        codigo_final := iniciais || timestamp_str || '-' || sufixo_aleatorio;
        
        -- Verificar se já existe
        IF NOT EXISTS (SELECT 1 FROM membros WHERE codigo_referencia = codigo_final) THEN
            EXIT;
        END IF;
        
        contador := contador + 1;
        
        -- Evitar loop infinito
        IF contador > 100 THEN
            codigo_final := iniciais || timestamp_str || '-' || LPAD(contador::TEXT, 4, '0');
            EXIT;
        END IF;
    END LOOP;
    
    RETURN codigo_final;
END;
$$;


ALTER FUNCTION public.gerar_codigo_referencia(p_nome_completo character varying) OWNER TO postgres;

--
-- TOC entry 316 (class 1255 OID 17715)
-- Name: gerar_escala_para_culto(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.gerar_escala_para_culto(p_culto_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_escala_id INTEGER;
    v_culto RECORD;
BEGIN
    -- Buscar dados do culto
    SELECT * INTO v_culto FROM cultos WHERE id = p_culto_id;
    
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Culto não encontrado: %', p_culto_id;
    END IF;
    
    -- Criar escala automaticamente
    INSERT INTO escalas (
        data_escala,
        tipo,
        status,
        culto_id,
        tipo_evento,
        observacoes,
        created_at
    ) VALUES (
        v_culto.data,
        'LOUVOR',
        'pendente',
        p_culto_id,
        v_culto.tipo,
        'Escala gerada automaticamente para: ' || COALESCE(v_culto.titulo, 'Culto'),
        NOW()
    ) RETURNING id INTO v_escala_id;
    
    RETURN v_escala_id;
END;
$$;


ALTER FUNCTION public.gerar_escala_para_culto(p_culto_id integer) OWNER TO postgres;

--
-- TOC entry 5542 (class 0 OID 0)
-- Dependencies: 316
-- Name: FUNCTION gerar_escala_para_culto(p_culto_id integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION public.gerar_escala_para_culto(p_culto_id integer) IS 'Gera uma escala de louvor automaticamente para um culto';


--
-- TOC entry 291 (class 1255 OID 16446)
-- Name: gerar_id_compacto(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.gerar_id_compacto(p_nome_completo character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
DECLARE
    letra_nome VARCHAR(1);
    letra_sobrenome VARCHAR(1);
    ano_str VARCHAR(4);
    mes_str VARCHAR(2);
    dia_str VARCHAR(2);
    hora_str VARCHAR(2);
    minuto_str VARCHAR(2);
    segundo_str VARCHAR(2);
    sufixo_aleatorio VARCHAR(4);
    codigo_final VARCHAR(30);
    contador INTEGER := 0;
    palavras TEXT[];
BEGIN
    -- Extrair primeira letra do nome e sobrenome
    palavras := STRING_TO_ARRAY(TRIM(p_nome_completo), ' ');
    letra_nome := UPPER(LEFT(palavras[1], 1));
    IF array_length(palavras, 1) > 1 THEN
        letra_sobrenome := UPPER(LEFT(palavras[array_length(palavras, 1)], 1));
    ELSE
        letra_sobrenome := 'X';
    END IF;

    ano_str := TO_CHAR(NOW(), 'YYYY');
    mes_str := TO_CHAR(NOW(), 'MM');
    dia_str := TO_CHAR(NOW(), 'DD');
    hora_str := TO_CHAR(NOW(), 'HH24');
    minuto_str := TO_CHAR(NOW(), 'MI');
    segundo_str := TO_CHAR(NOW(), 'SS');

    LOOP
        -- Sufixo aleatório (4 caracteres alfanuméricos)
        sufixo_aleatorio := UPPER(
            CHR(65 + (RANDOM() * 25)::INT) ||
            CHR(65 + (RANDOM() * 25)::INT) ||
            (RANDOM() * 9)::INT ||
            CHR(65 + (RANDOM() * 25)::INT)
        );

        -- Montar código final conforme solicitado
        codigo_final := letra_nome || letra_sobrenome || ano_str || mes_str || dia_str || hora_str || minuto_str || segundo_str || '-' || sufixo_aleatorio;

        -- Verificar se já existe
        IF NOT EXISTS (SELECT 1 FROM membros WHERE id = codigo_final) THEN
            EXIT;
        END IF;

        contador := contador + 1;

        -- Evitar loop infinito
        IF contador > 100 THEN
            codigo_final := letra_nome || letra_sobrenome || ano_str || mes_str || dia_str || hora_str || minuto_str || segundo_str || '-' || LPAD(contador::TEXT, 4, '0');
            EXIT;
        END IF;
    END LOOP;

    RETURN codigo_final;
END;
$$;


ALTER FUNCTION public.gerar_id_compacto(p_nome_completo character varying) OWNER TO postgres;

--
-- TOC entry 313 (class 1255 OID 17661)
-- Name: registrar_historico_escala(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.registrar_historico_escala() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO historico_escalas (escala_id, acao, descricao, dados_novos, realizado_por)
        VALUES (NEW.id, 'CRIADA', 'Escala criada', row_to_json(NEW), NEW.criado_por);
    ELSIF TG_OP = 'UPDATE' THEN
        IF OLD.status != NEW.status THEN
            INSERT INTO historico_escalas (escala_id, acao, descricao, dados_anteriores, dados_novos, realizado_por)
            VALUES (NEW.id, 'EDITADA', 
                    'Status alterado de ' || OLD.status || ' para ' || NEW.status,
                    row_to_json(OLD), row_to_json(NEW), NEW.atualizado_por);
        END IF;
        
        IF OLD.publicada = false AND NEW.publicada = true THEN
            INSERT INTO historico_escalas (escala_id, acao, descricao, realizado_por)
            VALUES (NEW.id, 'PUBLICADA', 'Escala publicada e notificações enviadas', NEW.atualizado_por);
        END IF;
    END IF;
    
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.registrar_historico_escala() OWNER TO postgres;

--
-- TOC entry 311 (class 1255 OID 16505)
-- Name: set_member_id(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.set_member_id() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
      DECLARE
          primeiro_nome varchar;
          resto_nome varchar;
      BEGIN
          IF NEW.id IS NULL THEN
              -- Usar nome e sobrenome, se não tiver sobrenome, usar nome_completo split
              IF NEW.sobrenome IS NOT NULL AND NEW.sobrenome != '' THEN
                  NEW.id = generate_member_id(NEW.nome, NEW.sobrenome);
              ELSE
                  -- Se não tem sobrenome, dividir nome_completo
                  primeiro_nome := SPLIT_PART(NEW.nome_completo, ' ', 1);
                  resto_nome := TRIM(SUBSTRING(NEW.nome_completo FROM LENGTH(primeiro_nome) + 1));
                  
                  IF resto_nome = '' THEN
                      resto_nome := primeiro_nome; -- Se só tem um nome, usar o mesmo
                  END IF;
                  
                  NEW.id = generate_member_id(primeiro_nome, resto_nome);
              END IF;
          END IF;
          RETURN NEW;
      END;
      $$;


ALTER FUNCTION public.set_member_id() OWNER TO postgres;

--
-- TOC entry 275 (class 1255 OID 16435)
-- Name: trigger_gerar_codigo_referencia(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.trigger_gerar_codigo_referencia() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.codigo_referencia IS NULL THEN
        NEW.codigo_referencia := gerar_codigo_referencia(NEW.nome_completo);
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.trigger_gerar_codigo_referencia() OWNER TO postgres;

--
-- TOC entry 310 (class 1255 OID 16447)
-- Name: trigger_gerar_id_com_sufixo(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.trigger_gerar_id_com_sufixo() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
      BEGIN
          IF NEW.id IS NULL OR NEW.id = '' THEN
              NEW.id := gerar_id_compacto(NEW.nome_completo);
          END IF;
          RETURN NEW;
      END;
      $$;


ALTER FUNCTION public.trigger_gerar_id_com_sufixo() OWNER TO postgres;

--
-- TOC entry 274 (class 1255 OID 16990)
-- Name: update_instrumentos_updated_at(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_instrumentos_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_instrumentos_updated_at() OWNER TO postgres;

--
-- TOC entry 276 (class 1255 OID 17086)
-- Name: update_louvor_funcoes_updated_at(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_louvor_funcoes_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_louvor_funcoes_updated_at() OWNER TO postgres;

--
-- TOC entry 283 (class 1255 OID 17680)
-- Name: update_musicas_updated_at(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_musicas_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_musicas_updated_at() OWNER TO postgres;

--
-- TOC entry 295 (class 1255 OID 17653)
-- Name: update_timestamp(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_timestamp() OWNER TO postgres;

--
-- TOC entry 282 (class 1255 OID 16407)
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_updated_at_column() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 259 (class 1259 OID 17553)
-- Name: calendario_louvor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.calendario_louvor (
    id integer NOT NULL,
    titulo character varying(200) NOT NULL,
    descricao text,
    data_inicio timestamp without time zone NOT NULL,
    data_fim timestamp without time zone,
    dia_inteiro boolean DEFAULT false,
    tipo character varying(50) NOT NULL,
    categoria character varying(50),
    cor character varying(7) DEFAULT '#3B82F6'::character varying,
    escala_id integer,
    grupo_id integer,
    local character varying(200),
    observacoes text,
    link_reuniao character varying(500),
    lembrete_antecedencia integer,
    notificacao_enviada boolean DEFAULT false,
    ativo boolean DEFAULT true,
    recorrente boolean DEFAULT false,
    regra_recorrencia json,
    criado_por text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.calendario_louvor OWNER TO postgres;

--
-- TOC entry 5543 (class 0 OID 0)
-- Dependencies: 259
-- Name: TABLE calendario_louvor; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.calendario_louvor IS 'Calendário exclusivo do ministério de louvor (separado do calendário geral da igreja)';


--
-- TOC entry 5544 (class 0 OID 0)
-- Dependencies: 259
-- Name: COLUMN calendario_louvor.tipo; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.calendario_louvor.tipo IS 'ESCALA: culto/evento | ENSAIO: ensaio da banda | REUNIAO: reunião ministerial | EVENTO: evento especial | ANIVERSARIO: aniversário de membro';


--
-- TOC entry 5545 (class 0 OID 0)
-- Dependencies: 259
-- Name: COLUMN calendario_louvor.escala_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.calendario_louvor.escala_id IS 'Vincula o evento a uma escala específica';


--
-- TOC entry 258 (class 1259 OID 17552)
-- Name: calendario_louvor_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.calendario_louvor_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.calendario_louvor_id_seq OWNER TO postgres;

--
-- TOC entry 5546 (class 0 OID 0)
-- Dependencies: 258
-- Name: calendario_louvor_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.calendario_louvor_id_seq OWNED BY public.calendario_louvor.id;


--
-- TOC entry 273 (class 1259 OID 18056)
-- Name: church_settings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.church_settings (
    id integer NOT NULL,
    nome character varying(255) NOT NULL,
    denominacao character varying(255),
    telefone character varying(20),
    email character varying(255),
    endereco text,
    cidade character varying(100),
    estado character varying(50),
    pais character varying(100),
    logo_url text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    cep character varying(10)
);


ALTER TABLE public.church_settings OWNER TO postgres;

--
-- TOC entry 272 (class 1259 OID 18055)
-- Name: church_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.church_settings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.church_settings_id_seq OWNER TO postgres;

--
-- TOC entry 5547 (class 0 OID 0)
-- Dependencies: 272
-- Name: church_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.church_settings_id_seq OWNED BY public.church_settings.id;


--
-- TOC entry 267 (class 1259 OID 17683)
-- Name: cultos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cultos (
    id integer NOT NULL,
    data date NOT NULL,
    horario time without time zone DEFAULT '19:00:00'::time without time zone,
    tipo character varying(50) DEFAULT 'Noite'::character varying,
    titulo character varying(200),
    descricao text,
    local character varying(200) DEFAULT 'Templo Principal'::character varying,
    status character varying(20) DEFAULT 'planejado'::character varying,
    pregador character varying(200),
    tema_mensagem text,
    observacoes text,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    created_by integer,
    ativo boolean DEFAULT true
);


ALTER TABLE public.cultos OWNER TO postgres;

--
-- TOC entry 5548 (class 0 OID 0)
-- Dependencies: 267
-- Name: TABLE cultos; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.cultos IS 'Registro de todos os cultos da igreja';


--
-- TOC entry 5549 (class 0 OID 0)
-- Dependencies: 267
-- Name: COLUMN cultos.tipo; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.cultos.tipo IS 'Tipo do culto: Manhã, Tarde, Noite, Especial';


--
-- TOC entry 5550 (class 0 OID 0)
-- Dependencies: 267
-- Name: COLUMN cultos.status; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.cultos.status IS 'Status: planejado, realizado, cancelado';


--
-- TOC entry 266 (class 1259 OID 17682)
-- Name: cultos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cultos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cultos_id_seq OWNER TO postgres;

--
-- TOC entry 5551 (class 0 OID 0)
-- Dependencies: 266
-- Name: cultos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cultos_id_seq OWNED BY public.cultos.id;


--
-- TOC entry 257 (class 1259 OID 17532)
-- Name: escala_musicas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.escala_musicas (
    id integer NOT NULL,
    escala_id integer NOT NULL,
    titulo character varying(200) NOT NULL,
    artista character varying(200),
    tonalidade character varying(10),
    bpm integer,
    ordem integer DEFAULT 1 NOT NULL,
    momento character varying(50),
    link_cifra character varying(500),
    link_audio character varying(500),
    link_video character varying(500),
    observacoes text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.escala_musicas OWNER TO postgres;

--
-- TOC entry 5552 (class 0 OID 0)
-- Dependencies: 257
-- Name: TABLE escala_musicas; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.escala_musicas IS 'Setlist - músicas que serão ministradas em cada escala';


--
-- TOC entry 5553 (class 0 OID 0)
-- Dependencies: 257
-- Name: COLUMN escala_musicas.momento; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.escala_musicas.momento IS 'Momento do culto em que a música será tocada';


--
-- TOC entry 256 (class 1259 OID 17531)
-- Name: escala_musicas_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.escala_musicas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.escala_musicas_id_seq OWNER TO postgres;

--
-- TOC entry 5554 (class 0 OID 0)
-- Dependencies: 256
-- Name: escala_musicas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.escala_musicas_id_seq OWNED BY public.escala_musicas.id;


--
-- TOC entry 255 (class 1259 OID 17494)
-- Name: escala_participantes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.escala_participantes (
    id integer NOT NULL,
    escala_id integer NOT NULL,
    membro_id text NOT NULL,
    funcao_id integer NOT NULL,
    confirmado boolean DEFAULT false,
    data_confirmacao timestamp without time zone,
    presente boolean,
    observacoes text,
    substituto_de text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.escala_participantes OWNER TO postgres;

--
-- TOC entry 5555 (class 0 OID 0)
-- Dependencies: 255
-- Name: TABLE escala_participantes; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.escala_participantes IS 'Membros escalados em cada evento com suas funções';


--
-- TOC entry 5556 (class 0 OID 0)
-- Dependencies: 255
-- Name: COLUMN escala_participantes.substituto_de; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.escala_participantes.substituto_de IS 'Se este membro está substituindo outro';


--
-- TOC entry 254 (class 1259 OID 17493)
-- Name: escala_participantes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.escala_participantes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.escala_participantes_id_seq OWNER TO postgres;

--
-- TOC entry 5557 (class 0 OID 0)
-- Dependencies: 254
-- Name: escala_participantes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.escala_participantes_id_seq OWNED BY public.escala_participantes.id;


--
-- TOC entry 253 (class 1259 OID 17450)
-- Name: escalas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.escalas (
    id integer NOT NULL,
    uuid uuid DEFAULT public.uuid_generate_v4(),
    titulo character varying(200) NOT NULL,
    data_evento timestamp without time zone NOT NULL,
    hora_inicio time without time zone DEFAULT '09:00:00'::time without time zone NOT NULL,
    hora_fim time without time zone,
    tipo_evento character varying(50) DEFAULT 'CULTO'::character varying,
    grupo_id integer,
    ministro_responsavel_id text,
    local character varying(200) DEFAULT 'Templo Principal'::character varying,
    observacoes text,
    tema character varying(200),
    status character varying(20) DEFAULT 'RASCUNHO'::character varying,
    publicada boolean DEFAULT false,
    notificacao_enviada boolean DEFAULT false,
    criado_por text,
    atualizado_por text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    culto_id integer
);


ALTER TABLE public.escalas OWNER TO postgres;

--
-- TOC entry 5558 (class 0 OID 0)
-- Dependencies: 253
-- Name: TABLE escalas; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.escalas IS 'Escalas de louvor para cultos e eventos';


--
-- TOC entry 5559 (class 0 OID 0)
-- Dependencies: 253
-- Name: COLUMN escalas.uuid; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.escalas.uuid IS 'UUID para compartilhar escala via link';


--
-- TOC entry 5560 (class 0 OID 0)
-- Dependencies: 253
-- Name: COLUMN escalas.tipo_evento; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.escalas.tipo_evento IS 'Tipo: Culto, Ensaio, Especial, Vigília, etc';


--
-- TOC entry 5561 (class 0 OID 0)
-- Dependencies: 253
-- Name: COLUMN escalas.observacoes; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.escalas.observacoes IS 'Observações gerais sobre a escala';


--
-- TOC entry 5562 (class 0 OID 0)
-- Dependencies: 253
-- Name: COLUMN escalas.status; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.escalas.status IS 'RASCUNHO: em edição | PUBLICADA: visível para todos | CONFIRMADA: todos confirmaram | REALIZADA: evento já aconteceu | CANCELADA: cancelado';


--
-- TOC entry 5563 (class 0 OID 0)
-- Dependencies: 253
-- Name: COLUMN escalas.culto_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.escalas.culto_id IS 'Culto vinculado a esta escala';


--
-- TOC entry 252 (class 1259 OID 17449)
-- Name: escalas_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.escalas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.escalas_id_seq OWNER TO postgres;

--
-- TOC entry 5564 (class 0 OID 0)
-- Dependencies: 252
-- Name: escalas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.escalas_id_seq OWNED BY public.escalas.id;


--
-- TOC entry 247 (class 1259 OID 17381)
-- Name: funcoes_louvor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.funcoes_louvor (
    id integer NOT NULL,
    nome character varying(100) NOT NULL,
    categoria character varying(50) NOT NULL,
    icone character varying(50),
    ordem integer DEFAULT 0,
    ativo boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.funcoes_louvor OWNER TO postgres;

--
-- TOC entry 5565 (class 0 OID 0)
-- Dependencies: 247
-- Name: TABLE funcoes_louvor; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.funcoes_louvor IS 'Funções disponíveis no louvor (Vocal, Instrumentos, Técnico, etc)';


--
-- TOC entry 246 (class 1259 OID 17380)
-- Name: funcoes_louvor_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.funcoes_louvor_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.funcoes_louvor_id_seq OWNER TO postgres;

--
-- TOC entry 5566 (class 0 OID 0)
-- Dependencies: 246
-- Name: funcoes_louvor_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.funcoes_louvor_id_seq OWNED BY public.funcoes_louvor.id;


--
-- TOC entry 245 (class 1259 OID 17354)
-- Name: grupos_louvor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.grupos_louvor (
    id integer NOT NULL,
    nome character varying(100) NOT NULL,
    descricao text,
    cor character varying(7) DEFAULT '#3B82F6'::character varying,
    ativo boolean DEFAULT true,
    lider_id text,
    vice_lider_id text,
    observacoes text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.grupos_louvor OWNER TO postgres;

--
-- TOC entry 5567 (class 0 OID 0)
-- Dependencies: 245
-- Name: TABLE grupos_louvor; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.grupos_louvor IS 'Grupos/bandas do ministério de louvor (Banda 1, Banda 2, Coral, etc)';


--
-- TOC entry 5568 (class 0 OID 0)
-- Dependencies: 245
-- Name: COLUMN grupos_louvor.cor; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.grupos_louvor.cor IS 'Cor em hexadecimal para identificar o grupo no calendário visual';


--
-- TOC entry 244 (class 1259 OID 17353)
-- Name: grupos_louvor_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.grupos_louvor_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.grupos_louvor_id_seq OWNER TO postgres;

--
-- TOC entry 5569 (class 0 OID 0)
-- Dependencies: 244
-- Name: grupos_louvor_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.grupos_louvor_id_seq OWNED BY public.grupos_louvor.id;


--
-- TOC entry 263 (class 1259 OID 17612)
-- Name: historico_escalas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.historico_escalas (
    id integer NOT NULL,
    escala_id integer NOT NULL,
    acao character varying(50) NOT NULL,
    descricao text,
    dados_anteriores json,
    dados_novos json,
    realizado_por text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.historico_escalas OWNER TO postgres;

--
-- TOC entry 5570 (class 0 OID 0)
-- Dependencies: 263
-- Name: TABLE historico_escalas; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.historico_escalas IS 'Auditoria - registro de todas as mudanças nas escalas';


--
-- TOC entry 262 (class 1259 OID 17611)
-- Name: historico_escalas_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.historico_escalas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.historico_escalas_id_seq OWNER TO postgres;

--
-- TOC entry 5571 (class 0 OID 0)
-- Dependencies: 262
-- Name: historico_escalas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.historico_escalas_id_seq OWNED BY public.historico_escalas.id;


--
-- TOC entry 261 (class 1259 OID 17588)
-- Name: indisponibilidades; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.indisponibilidades (
    id integer NOT NULL,
    membro_id text NOT NULL,
    data_inicio date NOT NULL,
    data_fim date NOT NULL,
    recorrente boolean DEFAULT false,
    regra_recorrencia json,
    motivo character varying(200),
    descricao text,
    tipo character varying(50) DEFAULT 'PESSOAL'::character varying,
    ativo boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_datas CHECK ((data_fim >= data_inicio))
);


ALTER TABLE public.indisponibilidades OWNER TO postgres;

--
-- TOC entry 5572 (class 0 OID 0)
-- Dependencies: 261
-- Name: TABLE indisponibilidades; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.indisponibilidades IS 'Períodos em que membros não podem ser escalados';


--
-- TOC entry 5573 (class 0 OID 0)
-- Dependencies: 261
-- Name: COLUMN indisponibilidades.recorrente; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.indisponibilidades.recorrente IS 'Se a indisponibilidade se repete (ex: todo domingo de manhã)';


--
-- TOC entry 260 (class 1259 OID 17587)
-- Name: indisponibilidades_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.indisponibilidades_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.indisponibilidades_id_seq OWNER TO postgres;

--
-- TOC entry 5574 (class 0 OID 0)
-- Dependencies: 260
-- Name: indisponibilidades_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.indisponibilidades_id_seq OWNED BY public.indisponibilidades.id;


--
-- TOC entry 225 (class 1259 OID 16721)
-- Name: instrumentos_equipamentos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.instrumentos_equipamentos (
    id integer NOT NULL,
    nome character varying(200) NOT NULL,
    tipo character varying(50),
    marca character varying(100),
    modelo character varying(100),
    numero_serie character varying(100),
    propriedade character varying(50) DEFAULT 'Igreja'::character varying,
    estado_conservacao character varying(20) DEFAULT 'Bom'::character varying,
    responsavel_id character varying(30),
    localizacao character varying(200),
    valor_compra numeric(10,2),
    data_compra date,
    observacoes text,
    ativo boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.instrumentos_equipamentos OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 16720)
-- Name: instrumentos_equipamentos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.instrumentos_equipamentos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.instrumentos_equipamentos_id_seq OWNER TO postgres;

--
-- TOC entry 5575 (class 0 OID 0)
-- Dependencies: 224
-- Name: instrumentos_equipamentos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.instrumentos_equipamentos_id_seq OWNED BY public.instrumentos_equipamentos.id;


--
-- TOC entry 237 (class 1259 OID 16958)
-- Name: instrumentos_inventario; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.instrumentos_inventario (
    id integer NOT NULL,
    codigo character varying(50) NOT NULL,
    nome character varying(200) NOT NULL,
    usuario_id integer,
    ultima_manutencao date,
    proxima_manutencao date,
    origem character varying(20) NOT NULL,
    doador character varying(200),
    valor_compra numeric(10,2),
    data_aquisicao date,
    status character varying(20) DEFAULT 'ATIVO'::character varying,
    observacoes text,
    localizacao character varying(200),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    created_by integer,
    CONSTRAINT instrumentos_inventario_origem_check CHECK (((origem)::text = ANY ((ARRAY['DOADO'::character varying, 'COMPRADO'::character varying])::text[]))),
    CONSTRAINT instrumentos_inventario_status_check CHECK (((status)::text = ANY ((ARRAY['ATIVO'::character varying, 'MANUTENCAO'::character varying, 'INATIVO'::character varying])::text[])))
);


ALTER TABLE public.instrumentos_inventario OWNER TO postgres;

--
-- TOC entry 5576 (class 0 OID 0)
-- Dependencies: 237
-- Name: TABLE instrumentos_inventario; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.instrumentos_inventario IS 'Inventário completo de instrumentos musicais do ministério';


--
-- TOC entry 5577 (class 0 OID 0)
-- Dependencies: 237
-- Name: COLUMN instrumentos_inventario.codigo; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.instrumentos_inventario.codigo IS 'Código único de identificação do instrumento (ex: GUIT-001)';


--
-- TOC entry 5578 (class 0 OID 0)
-- Dependencies: 237
-- Name: COLUMN instrumentos_inventario.origem; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.instrumentos_inventario.origem IS 'Origem do instrumento: DOADO ou COMPRADO';


--
-- TOC entry 5579 (class 0 OID 0)
-- Dependencies: 237
-- Name: COLUMN instrumentos_inventario.status; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.instrumentos_inventario.status IS 'Status atual: ATIVO, MANUTENCAO ou INATIVO';


--
-- TOC entry 236 (class 1259 OID 16957)
-- Name: instrumentos_inventario_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.instrumentos_inventario_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.instrumentos_inventario_id_seq OWNER TO postgres;

--
-- TOC entry 5580 (class 0 OID 0)
-- Dependencies: 236
-- Name: instrumentos_inventario_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.instrumentos_inventario_id_seq OWNED BY public.instrumentos_inventario.id;


--
-- TOC entry 239 (class 1259 OID 16993)
-- Name: instrumentos_manutencoes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.instrumentos_manutencoes (
    id integer NOT NULL,
    instrumento_id integer NOT NULL,
    data_manutencao date NOT NULL,
    tipo_manutencao character varying(100),
    descricao text,
    custo numeric(10,2),
    responsavel character varying(200),
    status character varying(20) DEFAULT 'CONCLUIDA'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    created_by integer,
    CONSTRAINT instrumentos_manutencoes_status_check CHECK (((status)::text = ANY ((ARRAY['PENDENTE'::character varying, 'EM_ANDAMENTO'::character varying, 'CONCLUIDA'::character varying])::text[])))
);


ALTER TABLE public.instrumentos_manutencoes OWNER TO postgres;

--
-- TOC entry 5581 (class 0 OID 0)
-- Dependencies: 239
-- Name: TABLE instrumentos_manutencoes; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.instrumentos_manutencoes IS 'Histórico de manutenções realizadas nos instrumentos';


--
-- TOC entry 238 (class 1259 OID 16992)
-- Name: instrumentos_manutencoes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.instrumentos_manutencoes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.instrumentos_manutencoes_id_seq OWNER TO postgres;

--
-- TOC entry 5582 (class 0 OID 0)
-- Dependencies: 238
-- Name: instrumentos_manutencoes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.instrumentos_manutencoes_id_seq OWNED BY public.instrumentos_manutencoes.id;


--
-- TOC entry 241 (class 1259 OID 17020)
-- Name: instrumentos_tipos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.instrumentos_tipos (
    id integer NOT NULL,
    nome character varying(100) NOT NULL,
    categoria character varying(50),
    ativo boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.instrumentos_tipos OWNER TO postgres;

--
-- TOC entry 240 (class 1259 OID 17019)
-- Name: instrumentos_tipos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.instrumentos_tipos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.instrumentos_tipos_id_seq OWNER TO postgres;

--
-- TOC entry 5583 (class 0 OID 0)
-- Dependencies: 240
-- Name: instrumentos_tipos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.instrumentos_tipos_id_seq OWNED BY public.instrumentos_tipos.id;


--
-- TOC entry 243 (class 1259 OID 17152)
-- Name: inventario; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.inventario (
    id integer NOT NULL,
    nome_item character varying(200) NOT NULL,
    categoria character varying(100),
    descricao text,
    marca character varying(100),
    modelo character varying(100),
    numero_serie character varying(100),
    quantidade integer DEFAULT 1 NOT NULL,
    quantidade_minima integer DEFAULT 1,
    valor_unitario numeric(10,2),
    valor_total numeric(10,2) GENERATED ALWAYS AS (((quantidade)::numeric * COALESCE(valor_unitario, (0)::numeric))) STORED,
    data_inventario date DEFAULT CURRENT_DATE NOT NULL,
    data_aquisicao date,
    data_ultima_manutencao date,
    proxima_manutencao date,
    estado character varying(50) DEFAULT 'bom'::character varying,
    localizacao character varying(200),
    responsavel character varying(200),
    foto_url character varying(500),
    ativo boolean DEFAULT true,
    emprestado boolean DEFAULT false,
    emprestado_para character varying(200),
    data_emprestimo date,
    data_devolucao_prevista date,
    observacoes text,
    historico_manutencao text,
    data_criacao timestamp with time zone DEFAULT now(),
    data_atualizacao timestamp with time zone DEFAULT now(),
    criado_por integer,
    atualizado_por integer,
    CONSTRAINT inventario_estado_check CHECK (((estado)::text = ANY ((ARRAY['excelente'::character varying, 'bom'::character varying, 'regular'::character varying, 'ruim'::character varying, 'quebrado'::character varying, 'em_manutencao'::character varying])::text[]))),
    CONSTRAINT inventario_quantidade_check CHECK ((quantidade >= 0))
);


ALTER TABLE public.inventario OWNER TO postgres;

--
-- TOC entry 242 (class 1259 OID 17151)
-- Name: inventario_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.inventario_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.inventario_id_seq OWNER TO postgres;

--
-- TOC entry 5584 (class 0 OID 0)
-- Dependencies: 242
-- Name: inventario_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.inventario_id_seq OWNED BY public.inventario.id;


--
-- TOC entry 227 (class 1259 OID 16742)
-- Name: manutencoes_instrumentos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.manutencoes_instrumentos (
    id integer NOT NULL,
    instrumento_id integer,
    data_manutencao date NOT NULL,
    tipo_manutencao character varying(50),
    descricao text NOT NULL,
    custo numeric(10,2) DEFAULT 0,
    executado_por character varying(200),
    proximo_manutencao date,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.manutencoes_instrumentos OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 16741)
-- Name: manutencoes_instrumentos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.manutencoes_instrumentos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.manutencoes_instrumentos_id_seq OWNER TO postgres;

--
-- TOC entry 5585 (class 0 OID 0)
-- Dependencies: 226
-- Name: manutencoes_instrumentos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.manutencoes_instrumentos_id_seq OWNED BY public.manutencoes_instrumentos.id;


--
-- TOC entry 221 (class 1259 OID 16467)
-- Name: membros; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.membros (
    id character varying(30) NOT NULL,
    id_externo character varying(50),
    nome character varying(100) NOT NULL,
    sobrenome character varying(100) NOT NULL,
    nome_completo character varying(200),
    data_nascimento date,
    idade integer,
    mes character varying(20),
    telefone character varying(30),
    sexo character varying(20),
    observacoes text,
    status_civil character varying(30),
    conjuge character varying(100),
    parentesco character varying(100),
    rua character varying(100),
    numero character varying(20),
    bairro character varying(100),
    cidade character varying(100),
    estado character varying(10),
    cep character varying(20),
    batizado boolean,
    membro boolean,
    situacao_atual character varying(30),
    lider boolean,
    e_professor_ebq boolean,
    faixa_etaria character varying(50),
    pequeno_grupo boolean,
    grupo character varying(100),
    numerodomes integer,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    avatar_url character varying(255),
    ministro boolean DEFAULT false
);


ALTER TABLE public.membros OWNER TO postgres;

--
-- TOC entry 249 (class 1259 OID 17396)
-- Name: membros_funcoes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.membros_funcoes (
    id integer NOT NULL,
    membro_id text NOT NULL,
    funcao_id integer NOT NULL,
    nivel_habilidade character varying(20) DEFAULT 'INTERMEDIARIO'::character varying,
    preferencia boolean DEFAULT false,
    observacoes text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.membros_funcoes OWNER TO postgres;

--
-- TOC entry 5586 (class 0 OID 0)
-- Dependencies: 249
-- Name: TABLE membros_funcoes; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.membros_funcoes IS 'Funções que cada membro pode desempenhar no louvor';


--
-- TOC entry 5587 (class 0 OID 0)
-- Dependencies: 249
-- Name: COLUMN membros_funcoes.preferencia; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.membros_funcoes.preferencia IS 'Indica se esta é a função preferencial do membro';


--
-- TOC entry 248 (class 1259 OID 17395)
-- Name: membros_funcoes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.membros_funcoes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.membros_funcoes_id_seq OWNER TO postgres;

--
-- TOC entry 5588 (class 0 OID 0)
-- Dependencies: 248
-- Name: membros_funcoes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.membros_funcoes_id_seq OWNED BY public.membros_funcoes.id;


--
-- TOC entry 251 (class 1259 OID 17423)
-- Name: membros_grupos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.membros_grupos (
    id integer NOT NULL,
    membro_id text NOT NULL,
    grupo_id integer NOT NULL,
    ativo boolean DEFAULT true,
    data_entrada date DEFAULT CURRENT_DATE,
    data_saida date,
    observacoes text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.membros_grupos OWNER TO postgres;

--
-- TOC entry 5589 (class 0 OID 0)
-- Dependencies: 251
-- Name: TABLE membros_grupos; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.membros_grupos IS 'Membros que pertencem a cada grupo/banda';


--
-- TOC entry 250 (class 1259 OID 17422)
-- Name: membros_grupos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.membros_grupos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.membros_grupos_id_seq OWNER TO postgres;

--
-- TOC entry 5590 (class 0 OID 0)
-- Dependencies: 250
-- Name: membros_grupos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.membros_grupos_id_seq OWNED BY public.membros_grupos.id;


--
-- TOC entry 233 (class 1259 OID 16831)
-- Name: membros_igreja; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.membros_igreja (
    id integer NOT NULL,
    nome_completo character varying(200) NOT NULL,
    nome_preferido character varying(100),
    data_nascimento date,
    sexo character varying(10),
    estado_civil character varying(30),
    telefone character varying(30),
    email character varying(255),
    endereco_completo text,
    cep character varying(20),
    cidade character varying(100),
    estado character varying(50),
    batizado boolean DEFAULT false,
    data_batismo date,
    membro_oficial boolean DEFAULT false,
    data_membresia date,
    status_atual character varying(30) DEFAULT 'Ativo'::character varying,
    observacoes text,
    usuario_sistema_id integer,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.membros_igreja OWNER TO postgres;

--
-- TOC entry 5591 (class 0 OID 0)
-- Dependencies: 233
-- Name: TABLE membros_igreja; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.membros_igreja IS 'Membros da igreja (separado dos usuários do sistema)';


--
-- TOC entry 5592 (class 0 OID 0)
-- Dependencies: 233
-- Name: COLUMN membros_igreja.usuario_sistema_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.membros_igreja.usuario_sistema_id IS 'Referência opcional ao usuário do sistema';


--
-- TOC entry 232 (class 1259 OID 16830)
-- Name: membros_igreja_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.membros_igreja_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.membros_igreja_id_seq OWNER TO postgres;

--
-- TOC entry 5593 (class 0 OID 0)
-- Dependencies: 232
-- Name: membros_igreja_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.membros_igreja_id_seq OWNED BY public.membros_igreja.id;


--
-- TOC entry 223 (class 1259 OID 16660)
-- Name: musicas_acervo; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.musicas_acervo (
    id integer NOT NULL,
    titulo character varying(200) NOT NULL,
    artista character varying(200),
    tonalidade_padrao character varying(5),
    letra text,
    cifra text,
    link_youtube character varying(500),
    link_spotify character varying(500),
    tags text,
    ativo boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    observacoes text,
    duracao_segundos integer
);


ALTER TABLE public.musicas_acervo OWNER TO postgres;

--
-- TOC entry 5594 (class 0 OID 0)
-- Dependencies: 223
-- Name: TABLE musicas_acervo; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.musicas_acervo IS 'Acervo completo de músicas do ministério de louvor';


--
-- TOC entry 5595 (class 0 OID 0)
-- Dependencies: 223
-- Name: COLUMN musicas_acervo.titulo; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.musicas_acervo.titulo IS 'Título da música';


--
-- TOC entry 5596 (class 0 OID 0)
-- Dependencies: 223
-- Name: COLUMN musicas_acervo.artista; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.musicas_acervo.artista IS 'Nome do artista/banda';


--
-- TOC entry 5597 (class 0 OID 0)
-- Dependencies: 223
-- Name: COLUMN musicas_acervo.tonalidade_padrao; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.musicas_acervo.tonalidade_padrao IS 'Tom original ou mais usado (ex: C, G, Am)';


--
-- TOC entry 5598 (class 0 OID 0)
-- Dependencies: 223
-- Name: COLUMN musicas_acervo.tags; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.musicas_acervo.tags IS 'Tags em formato JSON: ["Adoração", "Rápida"]';


--
-- TOC entry 5599 (class 0 OID 0)
-- Dependencies: 223
-- Name: COLUMN musicas_acervo.ativo; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.musicas_acervo.ativo IS 'Se false, música foi removida (soft delete)';


--
-- TOC entry 222 (class 1259 OID 16659)
-- Name: musicas_acervo_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.musicas_acervo_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.musicas_acervo_id_seq OWNER TO postgres;

--
-- TOC entry 5600 (class 0 OID 0)
-- Dependencies: 222
-- Name: musicas_acervo_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.musicas_acervo_id_seq OWNED BY public.musicas_acervo.id;


--
-- TOC entry 229 (class 1259 OID 16785)
-- Name: niveis_acesso; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.niveis_acesso (
    id integer NOT NULL,
    codigo character varying(20) NOT NULL,
    nome character varying(50) NOT NULL,
    descricao text,
    nivel_hierarquico integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.niveis_acesso OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 16784)
-- Name: niveis_acesso_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.niveis_acesso_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.niveis_acesso_id_seq OWNER TO postgres;

--
-- TOC entry 5601 (class 0 OID 0)
-- Dependencies: 228
-- Name: niveis_acesso_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.niveis_acesso_id_seq OWNED BY public.niveis_acesso.id;


--
-- TOC entry 271 (class 1259 OID 18009)
-- Name: usuarios; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usuarios (
    id integer NOT NULL,
    username character varying(50) NOT NULL,
    senha_hash character varying(100) NOT NULL,
    tipo character varying(30) NOT NULL,
    membro_id text,
    ativo boolean DEFAULT true,
    criado_em timestamp without time zone DEFAULT now()
);


ALTER TABLE public.usuarios OWNER TO postgres;

--
-- TOC entry 270 (class 1259 OID 18008)
-- Name: usuarios_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.usuarios_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.usuarios_id_seq OWNER TO postgres;

--
-- TOC entry 5602 (class 0 OID 0)
-- Dependencies: 270
-- Name: usuarios_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.usuarios_id_seq OWNED BY public.usuarios.id;


--
-- TOC entry 235 (class 1259 OID 16903)
-- Name: usuarios_permissoes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usuarios_permissoes (
    id integer NOT NULL,
    usuario_id integer,
    pode_gerenciar_usuarios boolean DEFAULT false,
    pode_gerenciar_membros boolean DEFAULT false,
    pode_ver_relatorios boolean DEFAULT false,
    pode_fazer_backup boolean DEFAULT false,
    ministerios_permitidos integer[] DEFAULT '{}'::integer[],
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.usuarios_permissoes OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 16902)
-- Name: usuarios_permissoes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.usuarios_permissoes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.usuarios_permissoes_id_seq OWNER TO postgres;

--
-- TOC entry 5603 (class 0 OID 0)
-- Dependencies: 234
-- Name: usuarios_permissoes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.usuarios_permissoes_id_seq OWNED BY public.usuarios_permissoes.id;


--
-- TOC entry 231 (class 1259 OID 16801)
-- Name: usuarios_sistema; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usuarios_sistema (
    id integer NOT NULL,
    nome_usuario character varying(50) NOT NULL,
    senha_hash character varying(255) NOT NULL,
    nivel_acesso_id integer NOT NULL,
    nome_completo character varying(200),
    email character varying(255),
    telefone character varying(30),
    ativo boolean DEFAULT true,
    bloqueado boolean DEFAULT false,
    tentativas_login integer DEFAULT 0,
    bloqueado_ate timestamp without time zone,
    ultimo_login timestamp without time zone,
    ultimo_ip character varying(50),
    criado_por integer,
    token_reset character varying(255),
    token_expira timestamp without time zone,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.usuarios_sistema OWNER TO postgres;

--
-- TOC entry 5604 (class 0 OID 0)
-- Dependencies: 231
-- Name: TABLE usuarios_sistema; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.usuarios_sistema IS 'Usuários do sistema com acesso ao dashboard';


--
-- TOC entry 5605 (class 0 OID 0)
-- Dependencies: 231
-- Name: COLUMN usuarios_sistema.nome_usuario; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.usuarios_sistema.nome_usuario IS 'Login por nome, não por email';


--
-- TOC entry 5606 (class 0 OID 0)
-- Dependencies: 231
-- Name: COLUMN usuarios_sistema.bloqueado; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.usuarios_sistema.bloqueado IS 'Usuário pode ser bloqueado pelo mestre/admin';


--
-- TOC entry 230 (class 1259 OID 16800)
-- Name: usuarios_sistema_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.usuarios_sistema_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.usuarios_sistema_id_seq OWNER TO postgres;

--
-- TOC entry 5607 (class 0 OID 0)
-- Dependencies: 230
-- Name: usuarios_sistema_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.usuarios_sistema_id_seq OWNED BY public.usuarios_sistema.id;


--
-- TOC entry 265 (class 1259 OID 17668)
-- Name: vw_calendario_mes_atual; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.vw_calendario_mes_atual AS
 SELECT c.id,
    c.titulo,
    c.data_inicio,
    c.data_fim,
    c.tipo,
    c.cor,
    c.local,
    g.nome AS grupo_nome,
    e.status AS escala_status
   FROM ((public.calendario_louvor c
     LEFT JOIN public.grupos_louvor g ON ((c.grupo_id = g.id)))
     LEFT JOIN public.escalas e ON ((c.escala_id = e.id)))
  WHERE ((c.ativo = true) AND (EXTRACT(month FROM c.data_inicio) = EXTRACT(month FROM CURRENT_DATE)) AND (EXTRACT(year FROM c.data_inicio) = EXTRACT(year FROM CURRENT_DATE)))
  ORDER BY c.data_inicio;


ALTER VIEW public.vw_calendario_mes_atual OWNER TO postgres;

--
-- TOC entry 268 (class 1259 OID 17717)
-- Name: vw_cultos_completos; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.vw_cultos_completos AS
 SELECT c.id,
    c.data,
    c.horario,
    c.tipo,
    c.titulo,
    c.descricao,
    c.local,
    c.status,
    c.pregador,
    c.tema_mensagem,
    c.observacoes AS culto_observacoes,
    c.created_at,
    c.ativo,
    e.id AS escala_id,
    e.status AS escala_status,
    e.observacoes AS escala_observacoes,
    ( SELECT count(*) AS count
           FROM public.escala_participantes
          WHERE ((escala_participantes.escala_id = e.id) AND (escala_participantes.confirmado = true))) AS participantes_confirmados,
    ( SELECT count(*) AS count
           FROM public.escala_musicas
          WHERE (escala_musicas.escala_id = e.id)) AS total_musicas,
    u.nome_completo AS criado_por
   FROM ((public.cultos c
     LEFT JOIN public.escalas e ON ((e.culto_id = c.id)))
     LEFT JOIN public.usuarios_sistema u ON ((c.created_by = u.id)))
  WHERE (c.ativo = true)
  ORDER BY c.data DESC, c.horario DESC;


ALTER VIEW public.vw_cultos_completos OWNER TO postgres;

--
-- TOC entry 5608 (class 0 OID 0)
-- Dependencies: 268
-- Name: VIEW vw_cultos_completos; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON VIEW public.vw_cultos_completos IS 'Visão completa de cultos com suas escalas e estatísticas';


--
-- TOC entry 264 (class 1259 OID 17663)
-- Name: vw_proximas_escalas; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.vw_proximas_escalas AS
SELECT
    NULL::integer AS id,
    NULL::character varying(200) AS titulo,
    NULL::timestamp without time zone AS data_evento,
    NULL::character varying(50) AS tipo_evento,
    NULL::character varying(20) AS status,
    NULL::character varying(200) AS local,
    NULL::character varying(100) AS grupo_nome,
    NULL::character varying(7) AS grupo_cor,
    NULL::character varying(200) AS ministro_responsavel,
    NULL::bigint AS total_participantes,
    NULL::bigint AS participantes_confirmados,
    NULL::bigint AS total_musicas;


ALTER VIEW public.vw_proximas_escalas OWNER TO postgres;

--
-- TOC entry 269 (class 1259 OID 17722)
-- Name: vw_proximos_cultos; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.vw_proximos_cultos AS
 SELECT id,
    data,
    horario,
    tipo,
    titulo,
    descricao,
    local,
    status,
    pregador,
    tema_mensagem,
    culto_observacoes,
    created_at,
    ativo,
    escala_id,
    escala_status,
    escala_observacoes,
    participantes_confirmados,
    total_musicas,
    criado_por
   FROM public.vw_cultos_completos
  WHERE ((data >= CURRENT_DATE) AND ((status)::text = ANY ((ARRAY['planejado'::character varying, 'realizado'::character varying])::text[])))
  ORDER BY data, horario
 LIMIT 10;


ALTER VIEW public.vw_proximos_cultos OWNER TO postgres;

--
-- TOC entry 5609 (class 0 OID 0)
-- Dependencies: 269
-- Name: VIEW vw_proximos_cultos; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON VIEW public.vw_proximos_cultos IS 'Próximos 10 cultos planejados';


--
-- TOC entry 5128 (class 2604 OID 17556)
-- Name: calendario_louvor id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.calendario_louvor ALTER COLUMN id SET DEFAULT nextval('public.calendario_louvor_id_seq'::regclass);


--
-- TOC entry 5155 (class 2604 OID 18059)
-- Name: church_settings id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.church_settings ALTER COLUMN id SET DEFAULT nextval('public.church_settings_id_seq'::regclass);


--
-- TOC entry 5144 (class 2604 OID 17686)
-- Name: cultos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cultos ALTER COLUMN id SET DEFAULT nextval('public.cultos_id_seq'::regclass);


--
-- TOC entry 5124 (class 2604 OID 17535)
-- Name: escala_musicas id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.escala_musicas ALTER COLUMN id SET DEFAULT nextval('public.escala_musicas_id_seq'::regclass);


--
-- TOC entry 5120 (class 2604 OID 17497)
-- Name: escala_participantes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.escala_participantes ALTER COLUMN id SET DEFAULT nextval('public.escala_participantes_id_seq'::regclass);


--
-- TOC entry 5110 (class 2604 OID 17453)
-- Name: escalas id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.escalas ALTER COLUMN id SET DEFAULT nextval('public.escalas_id_seq'::regclass);


--
-- TOC entry 5098 (class 2604 OID 17384)
-- Name: funcoes_louvor id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.funcoes_louvor ALTER COLUMN id SET DEFAULT nextval('public.funcoes_louvor_id_seq'::regclass);


--
-- TOC entry 5093 (class 2604 OID 17357)
-- Name: grupos_louvor id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grupos_louvor ALTER COLUMN id SET DEFAULT nextval('public.grupos_louvor_id_seq'::regclass);


--
-- TOC entry 5142 (class 2604 OID 17615)
-- Name: historico_escalas id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.historico_escalas ALTER COLUMN id SET DEFAULT nextval('public.historico_escalas_id_seq'::regclass);


--
-- TOC entry 5136 (class 2604 OID 17591)
-- Name: indisponibilidades id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.indisponibilidades ALTER COLUMN id SET DEFAULT nextval('public.indisponibilidades_id_seq'::regclass);


--
-- TOC entry 5041 (class 2604 OID 16724)
-- Name: instrumentos_equipamentos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instrumentos_equipamentos ALTER COLUMN id SET DEFAULT nextval('public.instrumentos_equipamentos_id_seq'::regclass);


--
-- TOC entry 5072 (class 2604 OID 16961)
-- Name: instrumentos_inventario id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instrumentos_inventario ALTER COLUMN id SET DEFAULT nextval('public.instrumentos_inventario_id_seq'::regclass);


--
-- TOC entry 5076 (class 2604 OID 16996)
-- Name: instrumentos_manutencoes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instrumentos_manutencoes ALTER COLUMN id SET DEFAULT nextval('public.instrumentos_manutencoes_id_seq'::regclass);


--
-- TOC entry 5079 (class 2604 OID 17023)
-- Name: instrumentos_tipos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instrumentos_tipos ALTER COLUMN id SET DEFAULT nextval('public.instrumentos_tipos_id_seq'::regclass);


--
-- TOC entry 5083 (class 2604 OID 17155)
-- Name: inventario id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventario ALTER COLUMN id SET DEFAULT nextval('public.inventario_id_seq'::regclass);


--
-- TOC entry 5047 (class 2604 OID 16745)
-- Name: manutencoes_instrumentos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.manutencoes_instrumentos ALTER COLUMN id SET DEFAULT nextval('public.manutencoes_instrumentos_id_seq'::regclass);


--
-- TOC entry 5102 (class 2604 OID 17399)
-- Name: membros_funcoes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.membros_funcoes ALTER COLUMN id SET DEFAULT nextval('public.membros_funcoes_id_seq'::regclass);


--
-- TOC entry 5106 (class 2604 OID 17426)
-- Name: membros_grupos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.membros_grupos ALTER COLUMN id SET DEFAULT nextval('public.membros_grupos_id_seq'::regclass);


--
-- TOC entry 5058 (class 2604 OID 16834)
-- Name: membros_igreja id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.membros_igreja ALTER COLUMN id SET DEFAULT nextval('public.membros_igreja_id_seq'::regclass);


--
-- TOC entry 5037 (class 2604 OID 16663)
-- Name: musicas_acervo id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.musicas_acervo ALTER COLUMN id SET DEFAULT nextval('public.musicas_acervo_id_seq'::regclass);


--
-- TOC entry 5050 (class 2604 OID 16788)
-- Name: niveis_acesso id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.niveis_acesso ALTER COLUMN id SET DEFAULT nextval('public.niveis_acesso_id_seq'::regclass);


--
-- TOC entry 5152 (class 2604 OID 18012)
-- Name: usuarios id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios ALTER COLUMN id SET DEFAULT nextval('public.usuarios_id_seq'::regclass);


--
-- TOC entry 5064 (class 2604 OID 16906)
-- Name: usuarios_permissoes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios_permissoes ALTER COLUMN id SET DEFAULT nextval('public.usuarios_permissoes_id_seq'::regclass);


--
-- TOC entry 5052 (class 2604 OID 16804)
-- Name: usuarios_sistema id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios_sistema ALTER COLUMN id SET DEFAULT nextval('public.usuarios_sistema_id_seq'::regclass);


--
-- TOC entry 5521 (class 0 OID 17553)
-- Dependencies: 259
-- Data for Name: calendario_louvor; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.calendario_louvor (id, titulo, descricao, data_inicio, data_fim, dia_inteiro, tipo, categoria, cor, escala_id, grupo_id, local, observacoes, link_reuniao, lembrete_antecedencia, notificacao_enviada, ativo, recorrente, regra_recorrencia, criado_por, created_at, updated_at) FROM stdin;
1	Culto de Celebração - Teste	Escala de louvor - CULTO	2025-11-10 00:00:00	2025-11-10 21:00:00	f	ESCALA	\N	#10B981	7	2	Templo Principal	Escala de teste criada automaticamente	\N	\N	f	t	f	\N	\N	2025-11-05 13:51:21.580448	2025-11-05 13:51:21.580448
\.


--
-- TOC entry 5531 (class 0 OID 18056)
-- Dependencies: 273
-- Data for Name: church_settings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.church_settings (id, nome, denominacao, telefone, email, endereco, cidade, estado, pais, logo_url, created_at, updated_at, cep) FROM stdin;
1	Igreja Batista Em Vila Palestina 	Ministério Batista		secretariaigreja.bvp@gmail.com	R. São João do Acre, 65 - Vila PalestinaCariacica - ES, 29145-790	Cariacica	ES	Brasil	/logos/church-logo.png	2025-12-16 17:06:24.207752	2026-04-10 17:09:35.223693	29140-000
\.


--
-- TOC entry 5527 (class 0 OID 17683)
-- Dependencies: 267
-- Data for Name: cultos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cultos (id, data, horario, tipo, titulo, descricao, local, status, pregador, tema_mensagem, observacoes, created_at, updated_at, created_by, ativo) FROM stdin;
1	2025-11-06	19:30:00	Noite	Culto Regular	Culto da IBVP	Templo Principal	planejado	Pr. Responsável	\N	\N	2025-11-05 16:14:58.897614	2025-11-05 16:14:58.897614	\N	t
2	2025-11-07	19:30:00	Noite	Culto Regular	Culto da IBVP	Templo Principal	planejado	Pr. Responsável	\N	\N	2025-11-05 16:14:58.897614	2025-11-05 16:14:58.897614	\N	t
3	2025-11-08	19:00:00	Noite	Culto de Doutrina	Culto da IBVP	Templo Principal	planejado	Pr. Responsável	\N	\N	2025-11-05 16:14:58.897614	2025-11-05 16:14:58.897614	\N	t
4	2025-11-09	19:30:00	Noite	Culto Regular	Culto da IBVP	Templo Principal	planejado	Pr. Responsável	\N	\N	2025-11-05 16:14:58.897614	2025-11-05 16:14:58.897614	\N	t
5	2025-11-10	19:30:00	Noite	Culto Regular	Culto da IBVP	Templo Principal	planejado	Pr. Responsável	\N	\N	2025-11-05 16:14:58.897614	2025-11-05 16:14:58.897614	\N	t
6	2025-11-11	19:30:00	Noite	Culto Regular	Culto da IBVP	Templo Principal	planejado	Pr. Responsável	\N	\N	2025-11-05 16:14:58.897614	2025-11-05 16:14:58.897614	\N	t
7	2025-11-12	10:00:00	Manhã	Culto de Celebração	Culto da IBVP	Templo Principal	planejado	Pr. Responsável	\N	\N	2025-11-05 16:14:58.897614	2025-11-05 16:14:58.897614	\N	t
8	2025-11-13	19:30:00	Noite	Culto Regular	Culto da IBVP	Templo Principal	planejado	Pr. Responsável	\N	\N	2025-11-05 16:14:58.897614	2025-11-05 16:14:58.897614	\N	t
9	2025-11-14	19:30:00	Noite	Culto Regular	Culto da IBVP	Templo Principal	planejado	Pr. Responsável	\N	\N	2025-11-05 16:14:58.897614	2025-11-05 16:14:58.897614	\N	t
10	2025-11-15	19:00:00	Noite	Culto de Doutrina	Culto da IBVP	Templo Principal	planejado	Pr. Responsável	\N	\N	2025-11-05 16:14:58.897614	2025-11-05 16:14:58.897614	\N	t
11	2025-11-16	19:30:00	Noite	Culto Regular	Culto da IBVP	Templo Principal	planejado	Pr. Responsável	\N	\N	2025-11-05 16:14:58.897614	2025-11-05 16:14:58.897614	\N	t
12	2025-11-17	19:30:00	Noite	Culto Regular	Culto da IBVP	Templo Principal	planejado	Pr. Responsável	\N	\N	2025-11-05 16:14:58.897614	2025-11-05 16:14:58.897614	\N	t
13	2025-11-18	19:30:00	Noite	Culto Regular	Culto da IBVP	Templo Principal	planejado	Pr. Responsável	\N	\N	2025-11-05 16:14:58.897614	2025-11-05 16:14:58.897614	\N	t
14	2025-11-19	10:00:00	Manhã	Culto de Celebração	Culto da IBVP	Templo Principal	planejado	Pr. Responsável	\N	\N	2025-11-05 16:14:58.897614	2025-11-05 16:14:58.897614	\N	t
15	2025-11-20	19:30:00	Noite	Culto Regular	Culto da IBVP	Templo Principal	planejado	Pr. Responsável	\N	\N	2025-11-05 16:14:58.897614	2025-11-05 16:14:58.897614	\N	t
16	2025-11-21	19:30:00	Noite	Culto Regular	Culto da IBVP	Templo Principal	planejado	Pr. Responsável	\N	\N	2025-11-05 16:14:58.897614	2025-11-05 16:14:58.897614	\N	t
17	2025-11-22	19:00:00	Noite	Culto de Doutrina	Culto da IBVP	Templo Principal	planejado	Pr. Responsável	\N	\N	2025-11-05 16:14:58.897614	2025-11-05 16:14:58.897614	\N	t
18	2025-11-23	19:30:00	Noite	Culto Regular	Culto da IBVP	Templo Principal	planejado	Pr. Responsável	\N	\N	2025-11-05 16:14:58.897614	2025-11-05 16:14:58.897614	\N	t
19	2025-11-24	19:30:00	Noite	Culto Regular	Culto da IBVP	Templo Principal	planejado	Pr. Responsável	\N	\N	2025-11-05 16:14:58.897614	2025-11-05 16:14:58.897614	\N	t
20	2025-11-25	19:30:00	Noite	Culto Regular	Culto da IBVP	Templo Principal	planejado	Pr. Responsável	\N	\N	2025-11-05 16:14:58.897614	2025-11-05 16:14:58.897614	\N	t
21	2025-11-26	10:00:00	Manhã	Culto de Celebração	Culto da IBVP	Templo Principal	planejado	Pr. Responsável	\N	\N	2025-11-05 16:14:58.897614	2025-11-05 16:14:58.897614	\N	t
22	2025-11-27	19:30:00	Noite	Culto Regular	Culto da IBVP	Templo Principal	planejado	Pr. Responsável	\N	\N	2025-11-05 16:14:58.897614	2025-11-05 16:14:58.897614	\N	t
23	2025-11-28	19:30:00	Noite	Culto Regular	Culto da IBVP	Templo Principal	planejado	Pr. Responsável	\N	\N	2025-11-05 16:14:58.897614	2025-11-05 16:14:58.897614	\N	t
24	2025-11-29	19:00:00	Noite	Culto de Doutrina	Culto da IBVP	Templo Principal	planejado	Pr. Responsável	\N	\N	2025-11-05 16:14:58.897614	2025-11-05 16:14:58.897614	\N	t
25	2025-11-30	19:30:00	Noite	Culto Regular	Culto da IBVP	Templo Principal	planejado	Pr. Responsável	\N	\N	2025-11-05 16:14:58.897614	2025-11-05 16:14:58.897614	\N	t
26	2025-12-01	19:30:00	Noite	Culto Regular	Culto da IBVP	Templo Principal	planejado	Pr. Responsável	\N	\N	2025-11-05 16:14:58.897614	2025-11-05 16:14:58.897614	\N	t
27	2025-12-02	19:30:00	Noite	Culto Regular	Culto da IBVP	Templo Principal	planejado	Pr. Responsável	\N	\N	2025-11-05 16:14:58.897614	2025-11-05 16:14:58.897614	\N	t
28	2025-12-03	10:00:00	Manhã	Culto de Celebração	Culto da IBVP	Templo Principal	planejado	Pr. Responsável	\N	\N	2025-11-05 16:14:58.897614	2025-11-05 16:14:58.897614	\N	t
29	2025-12-04	19:30:00	Noite	Culto Regular	Culto da IBVP	Templo Principal	planejado	Pr. Responsável	\N	\N	2025-11-05 16:14:58.897614	2025-11-05 16:14:58.897614	\N	t
30	2025-12-05	19:30:00	Noite	Culto Regular	Culto da IBVP	Templo Principal	planejado	Pr. Responsável	\N	\N	2025-11-05 16:14:58.897614	2025-11-05 16:14:58.897614	\N	t
\.


--
-- TOC entry 5519 (class 0 OID 17532)
-- Dependencies: 257
-- Data for Name: escala_musicas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.escala_musicas (id, escala_id, titulo, artista, tonalidade, bpm, ordem, momento, link_cifra, link_audio, link_video, observacoes, created_at, updated_at) FROM stdin;
1	5	Ruja o Leão	Davi Sacer	G	\N	1	ABERTURA	\N	\N	\N	\N	2025-11-05 13:43:13.275143	2025-11-05 13:43:13.275143
2	5	Tua Graça me Basta	Preto no Branco	D	\N	2	ADORACAO	\N	\N	\N	\N	2025-11-05 13:43:13.29817	2025-11-05 13:43:13.29817
3	5	Deus de Promessas	Toque no Altar	A	\N	3	OFERTA	\N	\N	\N	\N	2025-11-05 13:43:13.304064	2025-11-05 13:43:13.304064
4	6	Ruja o Leão	Davi Sacer	G	\N	1	ABERTURA	\N	\N	\N	\N	2025-11-05 13:49:22.543028	2025-11-05 13:49:22.543028
5	6	Tua Graça me Basta	Preto no Branco	D	\N	2	ADORACAO	\N	\N	\N	\N	2025-11-05 13:49:22.562835	2025-11-05 13:49:22.562835
6	6	Deus de Promessas	Toque no Altar	A	\N	3	OFERTA	\N	\N	\N	\N	2025-11-05 13:49:22.575979	2025-11-05 13:49:22.575979
7	7	Ruja o Leão	Davi Sacer	G	\N	1	ABERTURA	\N	\N	\N	\N	2025-11-05 13:51:21.131992	2025-11-05 13:51:21.131992
8	7	Tua Graça me Basta	Preto no Branco	D	\N	2	ADORACAO	\N	\N	\N	\N	2025-11-05 13:51:21.162527	2025-11-05 13:51:21.162527
9	7	Deus de Promessas	Toque no Altar	A	\N	3	OFERTA	\N	\N	\N	\N	2025-11-05 13:51:21.18329	2025-11-05 13:51:21.18329
\.


--
-- TOC entry 5517 (class 0 OID 17494)
-- Dependencies: 255
-- Data for Name: escala_participantes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.escala_participantes (id, escala_id, membro_id, funcao_id, confirmado, data_confirmacao, presente, observacoes, substituto_de, created_at, updated_at) FROM stdin;
2	7	AL20251104091147-WM7I	5	f	\N	\N	\N	\N	2025-11-05 13:51:21.477589	2025-11-05 13:51:21.477589
3	7	AS20251104091147-AC1C	4	f	\N	\N	\N	\N	2025-11-05 13:51:21.509012	2025-11-05 13:51:21.509012
\.


--
-- TOC entry 5515 (class 0 OID 17450)
-- Dependencies: 253
-- Data for Name: escalas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.escalas (id, uuid, titulo, data_evento, hora_inicio, hora_fim, tipo_evento, grupo_id, ministro_responsavel_id, local, observacoes, tema, status, publicada, notificacao_enviada, criado_por, atualizado_por, created_at, updated_at, culto_id) FROM stdin;
2	73b2b866-3938-4585-9369-68e9c1a9fdcc	Culto de Celebração - Teste	2025-11-10 00:00:00	19:00:00	21:00:00	CULTO	2	\N	Templo Principal	Escala de teste criada automaticamente	\N	RASCUNHO	f	f	\N	\N	2025-11-05 13:29:08.358625	2025-11-05 13:29:08.358625	\N
3	bbe95747-859a-4adb-aa64-50c399b990ac	Culto de Celebração - Teste	2025-11-10 00:00:00	19:00:00	21:00:00	CULTO	2	\N	Templo Principal	Escala de teste criada automaticamente	\N	RASCUNHO	f	f	\N	\N	2025-11-05 13:36:44.830881	2025-11-05 13:36:44.830881	\N
4	b713cb2b-d722-4ad8-a030-76f1857bddbd	Culto de Celebração - Teste	2025-11-10 00:00:00	19:00:00	21:00:00	CULTO	2	\N	Templo Principal	Escala de teste criada automaticamente	\N	RASCUNHO	f	f	\N	\N	2025-11-05 13:40:39.802517	2025-11-05 13:40:39.802517	\N
5	9645736a-f49b-4af6-be42-8824aca39abc	Culto de Celebração - Teste	2025-11-10 00:00:00	19:00:00	21:00:00	CULTO	2	\N	Templo Principal	Escala de teste criada automaticamente	\N	RASCUNHO	f	f	\N	\N	2025-11-05 13:43:13.213679	2025-11-05 13:43:13.213679	\N
6	1e57dea1-4b3c-4cb4-b811-ab982beed415	Culto de Celebração - Teste	2025-11-10 00:00:00	19:00:00	21:00:00	CULTO	2	\N	Templo Principal	Escala de teste criada automaticamente	\N	RASCUNHO	f	f	\N	\N	2025-11-05 13:49:22.445154	2025-11-05 13:49:22.445154	\N
7	10fc2ae0-24a6-41be-b54e-311ce1bf7ca2	Culto de Celebração - Teste	2025-11-10 00:00:00	19:00:00	21:00:00	CULTO	2	\N	Templo Principal	Escala de teste criada automaticamente	\N	PUBLICADA	t	f	\N	\N	2025-11-05 13:51:21.014984	2025-11-05 13:51:21.580448	\N
\.


--
-- TOC entry 5509 (class 0 OID 17381)
-- Dependencies: 247
-- Data for Name: funcoes_louvor; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.funcoes_louvor (id, nome, categoria, icone, ordem, ativo, created_at) FROM stdin;
1	Vocal Principal	VOCAL	Mic	1	t	2025-11-05 12:36:46.330963
2	Backing Vocal	VOCAL	Mic2	2	t	2025-11-05 12:36:46.330963
3	Guitarra	INSTRUMENTO	Guitar	3	t	2025-11-05 12:36:46.330963
4	Contrabaixo	INSTRUMENTO	Music	4	t	2025-11-05 12:36:46.330963
5	Bateria	INSTRUMENTO	Drum	5	t	2025-11-05 12:36:46.330963
6	Teclado	INSTRUMENTO	Piano	6	t	2025-11-05 12:36:46.330963
7	Violão	INSTRUMENTO	Music2	7	t	2025-11-05 12:36:46.330963
8	Saxofone	INSTRUMENTO	Music3	8	t	2025-11-05 12:36:46.330963
9	Som	TECNICO	Volume2	9	t	2025-11-05 12:36:46.330963
10	Projeção	TECNICO	Monitor	10	t	2025-11-05 12:36:46.330963
11	Ministro	MINISTERIO	UserCheck	11	t	2025-11-05 12:36:46.330963
\.


--
-- TOC entry 5507 (class 0 OID 17354)
-- Dependencies: 245
-- Data for Name: grupos_louvor; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.grupos_louvor (id, nome, descricao, cor, ativo, lider_id, vice_lider_id, observacoes, created_at, updated_at) FROM stdin;
1	Banda Principal	Grupo principal que ministra nos cultos de domingo	#3B82F6	t	\N	\N	\N	2025-11-05 12:36:46.330963	2025-11-05 12:36:46.330963
2	Banda Jovem	Grupo de jovens que ministra nos cultos de quarta-feira	#10B981	t	\N	\N	\N	2025-11-05 12:36:46.330963	2025-11-05 12:36:46.330963
3	Coral IBVP	Coral da igreja para eventos especiais	#8B5CF6	t	\N	\N	\N	2025-11-05 12:36:46.330963	2025-11-05 12:36:46.330963
\.


--
-- TOC entry 5525 (class 0 OID 17612)
-- Dependencies: 263
-- Data for Name: historico_escalas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.historico_escalas (id, escala_id, acao, descricao, dados_anteriores, dados_novos, realizado_por, created_at) FROM stdin;
1	2	CRIADA	Escala criada	\N	{"id":2,"uuid":"73b2b866-3938-4585-9369-68e9c1a9fdcc","titulo":"Culto de Celebração - Teste","data_evento":"2025-11-10T00:00:00","hora_inicio":"19:00:00","hora_fim":"21:00:00","tipo_evento":"CULTO","grupo_id":2,"ministro_responsavel_id":null,"local":"Templo Principal","observacoes":"Escala de teste criada automaticamente","tema":null,"status":"RASCUNHO","publicada":false,"notificacao_enviada":false,"criado_por":null,"atualizado_por":null,"created_at":"2025-11-05T13:29:08.358625","updated_at":"2025-11-05T13:29:08.358625"}	\N	2025-11-05 13:29:08.358625
2	3	CRIADA	Escala criada	\N	{"id":3,"uuid":"bbe95747-859a-4adb-aa64-50c399b990ac","titulo":"Culto de Celebração - Teste","data_evento":"2025-11-10T00:00:00","hora_inicio":"19:00:00","hora_fim":"21:00:00","tipo_evento":"CULTO","grupo_id":2,"ministro_responsavel_id":null,"local":"Templo Principal","observacoes":"Escala de teste criada automaticamente","tema":null,"status":"RASCUNHO","publicada":false,"notificacao_enviada":false,"criado_por":null,"atualizado_por":null,"created_at":"2025-11-05T13:36:44.830881","updated_at":"2025-11-05T13:36:44.830881"}	\N	2025-11-05 13:36:44.830881
3	4	CRIADA	Escala criada	\N	{"id":4,"uuid":"b713cb2b-d722-4ad8-a030-76f1857bddbd","titulo":"Culto de Celebração - Teste","data_evento":"2025-11-10T00:00:00","hora_inicio":"19:00:00","hora_fim":"21:00:00","tipo_evento":"CULTO","grupo_id":2,"ministro_responsavel_id":null,"local":"Templo Principal","observacoes":"Escala de teste criada automaticamente","tema":null,"status":"RASCUNHO","publicada":false,"notificacao_enviada":false,"criado_por":null,"atualizado_por":null,"created_at":"2025-11-05T13:40:39.802517","updated_at":"2025-11-05T13:40:39.802517"}	\N	2025-11-05 13:40:39.802517
4	5	CRIADA	Escala criada	\N	{"id":5,"uuid":"9645736a-f49b-4af6-be42-8824aca39abc","titulo":"Culto de Celebração - Teste","data_evento":"2025-11-10T00:00:00","hora_inicio":"19:00:00","hora_fim":"21:00:00","tipo_evento":"CULTO","grupo_id":2,"ministro_responsavel_id":null,"local":"Templo Principal","observacoes":"Escala de teste criada automaticamente","tema":null,"status":"RASCUNHO","publicada":false,"notificacao_enviada":false,"criado_por":null,"atualizado_por":null,"created_at":"2025-11-05T13:43:13.213679","updated_at":"2025-11-05T13:43:13.213679"}	\N	2025-11-05 13:43:13.213679
5	6	CRIADA	Escala criada	\N	{"id":6,"uuid":"1e57dea1-4b3c-4cb4-b811-ab982beed415","titulo":"Culto de Celebração - Teste","data_evento":"2025-11-10T00:00:00","hora_inicio":"19:00:00","hora_fim":"21:00:00","tipo_evento":"CULTO","grupo_id":2,"ministro_responsavel_id":null,"local":"Templo Principal","observacoes":"Escala de teste criada automaticamente","tema":null,"status":"RASCUNHO","publicada":false,"notificacao_enviada":false,"criado_por":null,"atualizado_por":null,"created_at":"2025-11-05T13:49:22.445154","updated_at":"2025-11-05T13:49:22.445154"}	\N	2025-11-05 13:49:22.445154
6	7	CRIADA	Escala criada	\N	{"id":7,"uuid":"10fc2ae0-24a6-41be-b54e-311ce1bf7ca2","titulo":"Culto de Celebração - Teste","data_evento":"2025-11-10T00:00:00","hora_inicio":"19:00:00","hora_fim":"21:00:00","tipo_evento":"CULTO","grupo_id":2,"ministro_responsavel_id":null,"local":"Templo Principal","observacoes":"Escala de teste criada automaticamente","tema":null,"status":"RASCUNHO","publicada":false,"notificacao_enviada":false,"criado_por":null,"atualizado_por":null,"created_at":"2025-11-05T13:51:21.014984","updated_at":"2025-11-05T13:51:21.014984"}	\N	2025-11-05 13:51:21.014984
7	7	EDITADA	Status alterado de RASCUNHO para PUBLICADA	{"id":7,"uuid":"10fc2ae0-24a6-41be-b54e-311ce1bf7ca2","titulo":"Culto de Celebração - Teste","data_evento":"2025-11-10T00:00:00","hora_inicio":"19:00:00","hora_fim":"21:00:00","tipo_evento":"CULTO","grupo_id":2,"ministro_responsavel_id":null,"local":"Templo Principal","observacoes":"Escala de teste criada automaticamente","tema":null,"status":"RASCUNHO","publicada":false,"notificacao_enviada":false,"criado_por":null,"atualizado_por":null,"created_at":"2025-11-05T13:51:21.014984","updated_at":"2025-11-05T13:51:21.014984"}	{"id":7,"uuid":"10fc2ae0-24a6-41be-b54e-311ce1bf7ca2","titulo":"Culto de Celebração - Teste","data_evento":"2025-11-10T00:00:00","hora_inicio":"19:00:00","hora_fim":"21:00:00","tipo_evento":"CULTO","grupo_id":2,"ministro_responsavel_id":null,"local":"Templo Principal","observacoes":"Escala de teste criada automaticamente","tema":null,"status":"PUBLICADA","publicada":true,"notificacao_enviada":false,"criado_por":null,"atualizado_por":null,"created_at":"2025-11-05T13:51:21.014984","updated_at":"2025-11-05T13:51:21.580448"}	\N	2025-11-05 13:51:21.580448
8	7	PUBLICADA	Escala publicada e notificações enviadas	\N	\N	\N	2025-11-05 13:51:21.580448
\.


--
-- TOC entry 5523 (class 0 OID 17588)
-- Dependencies: 261
-- Data for Name: indisponibilidades; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.indisponibilidades (id, membro_id, data_inicio, data_fim, recorrente, regra_recorrencia, motivo, descricao, tipo, ativo, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 5487 (class 0 OID 16721)
-- Dependencies: 225
-- Data for Name: instrumentos_equipamentos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.instrumentos_equipamentos (id, nome, tipo, marca, modelo, numero_serie, propriedade, estado_conservacao, responsavel_id, localizacao, valor_compra, data_compra, observacoes, ativo, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 5499 (class 0 OID 16958)
-- Dependencies: 237
-- Data for Name: instrumentos_inventario; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.instrumentos_inventario (id, codigo, nome, usuario_id, ultima_manutencao, proxima_manutencao, origem, doador, valor_compra, data_aquisicao, status, observacoes, localizacao, created_at, updated_at, created_by) FROM stdin;
1	GUIT-001	Guitarra Fender Stratocaster	\N	\N	\N	COMPRADO	\N	2500.00	\N	ATIVO	\N	\N	2025-11-05 15:24:42.388014	2025-11-05 15:24:42.388014	\N
2	BAIX-001	Baixo Ibanez SR300	\N	\N	\N	DOADO	João Silva	\N	\N	ATIVO	\N	\N	2025-11-05 15:24:42.533984	2025-11-05 15:24:42.533984	\N
3	BATE-001	Bateria Mapex Saturn	\N	\N	\N	COMPRADO	\N	5000.00	\N	ATIVO	\N	\N	2025-11-05 15:24:42.53932	2025-11-05 15:24:42.53932	\N
4	TECL-001	Teclado Yamaha PSR-E463	\N	\N	\N	COMPRADO	\N	1800.00	\N	ATIVO	\N	\N	2025-11-05 15:24:42.541057	2025-11-05 15:24:42.541057	\N
5	VIOL-001	Violão Giannini Acústico	\N	\N	\N	DOADO	Maria Santos	\N	\N	ATIVO	\N	\N	2025-11-05 15:24:42.542743	2025-11-05 15:24:42.542743	\N
6	CAJO-001	Cajón Percussion	\N	\N	\N	COMPRADO	\N	350.00	\N	ATIVO	\N	\N	2025-11-05 15:24:42.544169	2025-11-05 15:24:42.544169	\N
7	VOZ-001	Microfone Shure SM58	\N	\N	\N	COMPRADO	\N	450.00	\N	ATIVO	\N	\N	2025-11-05 15:24:42.547269	2025-11-05 15:24:42.547269	\N
\.


--
-- TOC entry 5501 (class 0 OID 16993)
-- Dependencies: 239
-- Data for Name: instrumentos_manutencoes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.instrumentos_manutencoes (id, instrumento_id, data_manutencao, tipo_manutencao, descricao, custo, responsavel, status, created_at, created_by) FROM stdin;
\.


--
-- TOC entry 5503 (class 0 OID 17020)
-- Dependencies: 241
-- Data for Name: instrumentos_tipos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.instrumentos_tipos (id, nome, categoria, ativo, created_at, updated_at) FROM stdin;
1	Violão	CORDAS	t	2025-11-04 18:47:43.951188	2025-11-04 18:47:43.951188
2	Guitarra	CORDAS	t	2025-11-04 18:47:43.951188	2025-11-04 18:47:43.951188
3	Contrabaixo	CORDAS	t	2025-11-04 18:47:43.951188	2025-11-04 18:47:43.951188
4	Piano	TECLADO	t	2025-11-04 18:47:43.951188	2025-11-04 18:47:43.951188
5	Teclado	TECLADO	t	2025-11-04 18:47:43.951188	2025-11-04 18:47:43.951188
6	Bateria	PERCUSSAO	t	2025-11-04 18:47:43.951188	2025-11-04 18:47:43.951188
7	Cajón	PERCUSSAO	t	2025-11-04 18:47:43.951188	2025-11-04 18:47:43.951188
8	Pandeiro	PERCUSSAO	t	2025-11-04 18:47:43.951188	2025-11-04 18:47:43.951188
9	Flauta	SOPRO	t	2025-11-04 18:47:43.951188	2025-11-04 18:47:43.951188
10	Saxofone	SOPRO	t	2025-11-04 18:47:43.951188	2025-11-04 18:47:43.951188
11	Trompete	SOPRO	t	2025-11-04 18:47:43.951188	2025-11-04 18:47:43.951188
12	Violino	CORDAS	t	2025-11-04 18:47:43.951188	2025-11-04 18:47:43.951188
13	Violoncelo	CORDAS	t	2025-11-04 18:47:43.951188	2025-11-04 18:47:43.951188
14	Acordeon	TECLADO	t	2025-11-04 18:47:43.951188	2025-11-04 18:47:43.951188
15	Contra Baixo	CORDAS	t	2025-11-04 19:34:36.640203	2025-11-04 19:34:36.640203
\.


--
-- TOC entry 5505 (class 0 OID 17152)
-- Dependencies: 243
-- Data for Name: inventario; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.inventario (id, nome_item, categoria, descricao, marca, modelo, numero_serie, quantidade, quantidade_minima, valor_unitario, data_inventario, data_aquisicao, data_ultima_manutencao, proxima_manutencao, estado, localizacao, responsavel, foto_url, ativo, emprestado, emprestado_para, data_emprestimo, data_devolucao_prevista, observacoes, historico_manutencao, data_criacao, data_atualizacao, criado_por, atualizado_por) FROM stdin;
\.


--
-- TOC entry 5489 (class 0 OID 16742)
-- Dependencies: 227
-- Data for Name: manutencoes_instrumentos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.manutencoes_instrumentos (id, instrumento_id, data_manutencao, tipo_manutencao, descricao, custo, executado_por, proximo_manutencao, created_at) FROM stdin;
\.


--
-- TOC entry 5483 (class 0 OID 16467)
-- Dependencies: 221
-- Data for Name: membros; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.membros (id, id_externo, nome, sobrenome, nome_completo, data_nascimento, idade, mes, telefone, sexo, observacoes, status_civil, conjuge, parentesco, rua, numero, bairro, cidade, estado, cep, batizado, membro, situacao_atual, lider, e_professor_ebq, faixa_etaria, pequeno_grupo, grupo, numerodomes, created_at, updated_at, avatar_url, ministro) FROM stdin;
HO20251104091150-HY1S	56	Hilda	Ferreira de Oliveira	Hilda Ferreira de Oliveira 	1937-04-05	89	abril	(27) 9 9999-4450	F	Viuva	Solteiro(a)	\N	\N	Porto Seguro 	216	Tiradentes	Cariacica	ES	29143-508	t	t	Ativo	f	f	60+	f	Sem Grupo	4	2025-11-04 09:11:50.505511	2026-05-11 16:39:04.15459	/avatars/HO20251104091150-HY1S.jpg	f
RI20251230113322-YR1X	164	Raniely	Pimentel Santa Clara Inácio	Raniely Pimentel Santa Clara Inácio	1998-04-28	28	abril	(27) 9 9754-9421	F	\N	\N	\N	\N	Das papoulas	161	Santo André	Cariacica	ES	29144-657	t	t	Ativo	f	f	18-29	f	Sem Grupo	4	2025-12-30 11:33:22.872175	2026-05-11 16:39:08.973426	/avatars/RI20251230113322-YR1X.jpg	f
JO20251104091150-AW7Y	62	Joscileia	Ferreira de Oliveira	Joscileia Ferreira de Oliveira 	1976-08-27	49	agosto	(27) 9 9999-4450	F		Casado(a)	Flávio Siqueira 	\N	Porto Seguro 	206	Tiradentes	Cariacica	ES	29143-508 	t	t	Ativo	f	t	45-59	f	Sem Grupo	8	2025-11-04 09:11:50.830388	2026-05-11 16:39:04.403386	\N	f
EI20251230113322-VM7N	165	Elisa	pimentel inacio	Elisa pimentel inacio	2024-10-05	1	outubro	(27) 9 9754-9421	F	\N	\N	\N	Filha de Raniely	Das papoulas	161	Santo André	Cariacica	ES	29144-657	f	f	Ativo	f	f	0-2	f	Sem Grupo	10	2025-12-30 11:33:22.913509	2026-05-11 16:39:09.005144	/avatars/EI20251230113322-VM7N.jpg	f
MR20251104091153-OI2U	104	Micaele	Rocha Rosa	Micaele Rocha Rosa 	2009-09-22	16	setembro	(27) 9 8827-6640	F	\N	Solteiro(a)	\N	Bruna Lorrani Rocha Mousinho 	Ametista 	34	São Geraldo	Cariacica	ES	29146-677	t	f	Desligado	f	f	12-17	f	Sem Grupo	9	2025-11-04 09:11:53.001745	2026-05-11 16:39:06.448575	\N	f
JA20251104091150-RK3W	63	Joseph	das Neves Azevedo	Joseph das Neves Azevedo 	1987-01-29	39	janeiro	(27) 9 9896-5321	M	\N	Casado(a)	Michelle Cornélio de Lima Azevedo	\N	Rua Bela Vista 	15	Arlindo Vilaschi	Viana	ES	29136-180	t	t	Ativo	f	f	30-44	f	Sem Grupo	1	2025-11-04 09:11:50.880061	2026-05-11 16:39:04.450975	/avatars/JA20251104091150-RK3W.jpg	f
MA20251104091153-CH8C	105	Michelle	Cornélio de Lima Azevedo	Michelle Cornélio de Lima Azevedo	1985-04-20	41	abril	(27) 9 9896-5321	F	\N	Casado(a)	Joseph das Neves Azevedo 	\N	Bela Vista	15	Arlindo Vilaschi	Viana	ES	29136-180	t	t	Ativo	f	f	30-44	f	Sem Grupo	4	2025-11-04 09:11:53.050998	2026-05-11 16:39:06.479361	/avatars/MA20251104091153-CH8C.jpg	f
OF20251104091153-BG6L	113	Odair	Arantes Alves - Falecido	Odair Arantes Alves - Falecido	1971-12-25	54	dezembro	(27) 9 9258-9813	M	Óbito 17/01/2025	Casado(a)	Maricelia da Cruz Izidoro Arantes Alves 	\N	Odonia da Costa Machado Toledo	311	Campina Grande	Cariacica	ES	29144-375	t	f	Desligado	f	f	45-59	f	Sem Grupo	12	2025-11-04 09:11:53.446674	2026-05-11 16:39:06.81881	\N	f
JR20251104091150-TP3T	65	Juliano	lovatti ramos	Juliano lovatti ramos	1979-08-08	46	agosto	(27) 9 8851-1191	M	Mudar para batizado	Casado(a)	Miriam da Rocha pina	Esposa	Rua São Luiz 	230	Itangua	Cariacica	ES	29149-771	t	t	Ativo	f	f	45-59	f	Sem Grupo	8	2025-11-04 09:11:50.975036	2026-05-11 16:39:04.542949	\N	f
RP20251104091153-ME6X	119	Rebeca	Arantes Alves Presenza	Rebeca Arantes Alves Presenza 	1999-04-03	27	abril	(27) 9 9887-6750	F		Casado(a)	Anderson Presenza Lima 	\N	São João 	38bf	Santo André	Cariacica	ES	29144-766	t	t	Ativo	f	f	18-29	f	Sem Grupo	4	2025-11-04 09:11:53.784099	2026-05-11 16:39:07.081657	/avatars/RP20251104091153-ME6X.jpg	f
LP20251104091151-ZB4S	73	Larissa	Ferreira de Morais Paulino	Larissa Ferreira de Morais Paulino	1988-05-23	37	maio	(27) 9 9919-7541	F	\N	Casado(a)	Flavio Paulino 	\N	Porto Seguro	237	Tiradentes	Cariacica	ES	29143-508 	t	t	Ativo	f	f	30-44	f	Sem Grupo	5	2025-11-04 09:11:51.391976	2026-05-11 16:39:05.017277	\N	f
TF20251104091154-LM2P	132	Terezinha	fontes	Terezinha fontes	1953-03-07	73	março	(27) 9 9936-8677	F	\N	Casado(a)	Antônio Francisco do Nascimento 	\N	Esmeralda	159	São Geraldo 1	Cariacica	ES	29146-675	t	t	Ativo	f	f	60+	f	Sem Grupo	3	2025-11-04 09:11:54.647755	2026-05-11 16:39:07.664788	/avatars/TF20251104091154-LM2P.jpg	f
LA20251104091151-UL3I	75	Laura	de Lima Azevedo	Laura de Lima Azevedo	2019-08-16	6	agosto	(27) 9 9896-5321	F	\N	Solteiro(a)	\N	Joseph das Neves Azevedo	Bela Vista 	15	Arlindo Vilaschi	Viana	ES	29136-180	f	f	Ativo	f	f	6-11	f	Sem Grupo	8	2025-11-04 09:11:51.497767	2026-05-11 16:39:05.109114	\N	f
VF20251104091155-JO1P	138	Vasthi	ferreira Gomes fraga	Vasthi ferreira Gomes fraga 	1973-06-25	52	junho	(27) 9 9772-3358	F	\N	Casado(a)	Nilson fraga Celestino 	\N	Atílio Esperandio 	249	Joana dark	Vitória	ES	29048-040	t	f	Desligado	f	f	45-59	f	Sem Grupo	6	2025-11-04 09:11:55.191989	2026-05-11 16:39:07.926612	\N	f
AL20251204143906-NF7R	155	Amanda	Carvalho da Silva Lira	Amanda Carvalho da Silva Lira	1994-05-31	31	maio	(27) 9 9836-7669	F	\N	\N	\N	Isaac Carvalho Lira (Filho)	Rua São Paulo dos Apostolos	282	Tucum	Cariacica	ES	29152-395	t	t	Ativo	f	f	30-44	f	Sem Grupo	5	2025-12-04 14:39:06.537797	2026-05-11 16:39:08.651221	/avatars/AL20251204143906-NF7R.jpg	f
LC20251104091151-SI3C	83	Lindalva	de Castro Pereira da Cruz	Lindalva de Castro Pereira da Cruz 	1970-05-13	55	maio	(27) 9 9875-6058	F	\N	Casado(a)	Levindo Lucas da Cruz Neto	\N	Av Glauber Rocha 	109	Morada de santa fé	Cariacica	ES	29143-732	t	t	Ativo	f	f	45-59	f	Sem Grupo	5	2025-11-04 09:11:51.900466	2026-05-11 16:39:05.575497	/avatars/LC20251104091151-SI3C.jpg	f
JP20251104091150-FH8X	57	Jair	Alves Pereira	Jair Alves Pereira 	1949-09-10	76	setembro	(27) 9 9809-4438	M	\N	Casado(a)	Elita da Penha Pego Pereira 	\N	São João do Acre 	68	Vila palestina	Cariacica	ES	29145-790	t	f	Desligado	f	f	60+	f	Sem Grupo	9	2025-11-04 09:11:50.554621	2026-05-11 16:39:04.199837	\N	f
MD20251104091153-LJ1H	106	Miguel	Will monteiro costa dias	Miguel Will monteiro costa dias 	2012-07-03	13	julho	(27) 9 9836-1927	M	\N	Solteiro(a)	\N	Bruna Will 	Abílio pontini 	145	São Geraldo 2	Cariacica	ES	29146-805	t	t	Ativo	f	f	12-17	f	Sem Grupo	7	2025-11-04 09:11:53.111094	2026-05-11 16:39:06.510243	\N	f
EM20251104091149-JP3O	41	Erielton	De paula Melo	Erielton De paula Melo 	1988-10-20	37	outubro	(27) 9 9622-5719	M		Casado(a)	Schaiany Pimentel Santa Clara de Paula 	\N	Das papoulas	161	Santo André	Cariacica	ES	29144-657	t	t	Ativo	f	t	30-44	f	Sem Grupo	10	2025-11-04 09:11:49.665131	2026-05-11 16:39:03.568758	/avatars/EM20251104091149-JP3O.jpg	f
WF20251104091155-SZ4G	143	Wendel	Araújo Fernandes	Wendel Araújo Fernandes 	1985-07-05	40	julho	(27) 9 9920-6322	M	\N	Solteiro(a)	\N	\N	Itabira 	38	São Geraldo 2	Cariacica	ES	29146-840	t	t	Ativo	f	f	30-44	f	Sem Grupo	7	2025-11-04 09:11:55.453922	2026-05-11 16:39:08.127625	\N	f
AV20251215095120-QS6H	158	Adriano	Evangelista Vieira	Adriano Evangelista Vieira 	1986-02-04	40	fevereiro	(27) 9 9828-7354	M	\N	\N	\N	\N	Santa Barbara 	103	Rosa da Penha	Cariacica	ES	29143-322	t	t	Ativo	f	f	30-44	f	Sem Grupo	2	2025-12-15 09:51:20.400519	2026-05-11 16:39:08.789155	/avatars/AV20251215095120-QS6H.jpg	f
GV20251104091150-SS1Z	54	Guilherme	dos Passos Siqueira Viana	Guilherme dos Passos Siqueira Viana 	2000-06-06	25	junho	(27) 9 8856-3571	M	\N	Casado(a)	Bruna Lorrani Rocha Mousinho Viana	\N	Ametista 	34	São Geraldo 1	Cariacica	ES	02914-677	t	t	Ativo	f	f	18-29	f	Sem Grupo	6	2025-11-04 09:11:50.387663	2026-05-11 16:39:04.078049	/avatars/GV20251104091150-SS1Z.jpg	f
JS20251104091150-MX9J	64	JOSHUA	ADAM CRUZ DE SOUSA	JOSHUA ADAM CRUZ DE SOUSA 	2013-04-04	13	abril	(27) 9 9987-9406	M	\N	Solteiro(a)	\N	ADELIDIA DE AZEVEDO CRUZ 	BOM PASTOR 	39	Campo Grande	Cariacica	ES	29146-060	t	t	Ativo	f	f	12-17	f	Sem Grupo	4	2025-11-04 09:11:50.927104	2026-05-11 16:39:04.496568	\N	f
JA20251104111353-PI0L	149	John	Mousinho Andrade	John Mousinho Andrade 	2024-11-19	1	novembro	(27) 9 9642-2970	M		Solteiro(a)	\N	Pais: Jhonatan de Souza Andrade e Grezieli Rocha Mousinho Andrade 	Rua crisólito 	18	São Geraldo	Cariacica	ES	29146-605	f	f	Ativo	f	f	0-2	f	Sem Grupo	11	2025-11-04 11:13:53.432203	2026-05-11 16:39:08.388666	/avatars/JA20251104111353-PI0L.jpg	f
LS20251104124723-UK5N	150	Lohanna	Oliveira Santos	Lohanna Oliveira Santos 	1995-01-02	31	janeiro	(27) 9 9872-8986	F		Casado(a)	Patrício Santos Evangelista 	Esposo	Sergipe 	1	Campina Grande	Cariacica	ES	29144-416	t	t	Ativo	f	f	30-44	f	Sem Grupo	1	2025-11-04 12:47:23.637178	2026-05-11 16:39:08.433781	/avatars/LS20251104124723-UK5N.jpg	f
MO20251127114645-LG6R	154	Matheus	Santos evangelista oliveira	Matheus Santos evangelista oliveira 	2017-10-11	8	outubro	(27) 9 9247-8715	M	\N	\N	\N	Patricio e lohanna . Pais 	Rua Sergipe 	1	Campina grande	Cariacica	ES	29144-418	f	f	Ativo	f	f	6-11	f	Sem Grupo	10	2025-11-27 11:46:45.054584	2026-05-11 16:39:08.60418	\N	f
JP20251216101258-VF6R	161	José	Felipe Marriel da Paixão	José Felipe Marriel da Paixão 	1990-02-25	36	fevereiro	(27) 9 9610-2460	M	\N	Casado(a)	Letícia de Souza Siqueira rocha Marriel 	Esposa 	Maria Zuleica de Siqueira Pádua 	Sn 	Ribeira	Viana	ES	29132-702	t	t	Ativo	f	f	30-44	f	Sem Grupo	2	2025-12-16 10:12:58.235794	2026-05-11 16:39:08.881324	\N	f
IL20251204143906-KK3K	156	Isaac	Carvalho Lira	Isaac Carvalho Lira	2022-05-28	3	maio	(27) 9 9836-7669	M	\N	\N	\N	Amanda Carvallho da Silva Lira (Mãe)	Rua São Paulo dos Apóstolos	282	Tucum	Cariacica	ES	29152-395	f	f	Ativo	f	f	3-5	f	Sem Grupo	5	2025-12-04 14:39:06.587713	2026-05-11 16:39:08.696897	/avatars/IL20251204143906-KK3K.jpg	f
BM20251216101258-CL3M	163	Bento	de Souza Marriel	Bento de Souza Marriel 	2024-02-26	2	fevereiro		M	\N	\N	\N	Filho	Maria Zuleica de Siqueira Pádua 	Sn	Ribeira	Viana	ES	29132-702	f	f	Ativo	f	f	0-2	f	Sem Grupo	2	2025-12-16 10:12:58.324132	2026-05-11 16:39:08.942417	/avatars/BM20251216101258-CL3M.jpg	f
CP20251104091148-RC5T	25	Christofer	de Andrade Pereira	Christofer de Andrade Pereira 	2022-05-23	3	maio	(27) 9 9811-4127	M	\N	Solteiro(a)	\N	Christian (Pai) Crislayne (Mãe)	Pavão 	27	São Conrado	Cariacica	ES	29141-195	f	f	Ativo	f	f	3-5	f	Sem Grupo	5	2025-11-04 09:11:48.883103	2026-05-11 16:39:02.981574	/avatars/CP20251104091148-RC5T.jpg	f
EJ20251104091149-WW1W	35	Edilson	Azevedo de Jesus	Edilson Azevedo de Jesus 	1976-08-07	49	agosto	(27) 9 9887-8752	M	\N	Casado(a)	Bruna Luiza Souza Silva de Jesus 	\N	São Benedito 	48	Cruzeiro do Sul	Cariacica	ES	29144-040	t	t	Desligado	f	f	45-59	f	Sem Grupo	8	2025-11-04 09:11:49.362756	2026-05-11 16:39:03.323494	\N	f
ÍL20251215095120-EG5U	159	Ítalo	Theodoro Lopes	Ítalo Theodoro Lopes	2025-10-31	0	outubro		M			\N	Pais Larissa e Richardson	Itaguaçu	35	Morada de Santa Fé	Cariacica	ES	29143-666	f	f	Ativo	f	f	0-2	f	Sem Grupo	10	2025-12-15 09:51:20.438483	2026-05-11 16:39:08.820917	/avatars/ÍL20251215095120-EG5U.jpg	f
NS20251216101258-ME8M	160	Nicolle	Fraga Dos Santos	Nicolle Fraga Dos Santos 	2007-06-14	18	junho	(27) 9 9292-0829	F	\N	\N	\N	\N	Avenida união 	750	Nova esperança	Conceição do Castelo	ES	29157-520	t	f	Ativo	f	f	18-29	f	Sem Grupo	6	2025-12-16 10:12:58.139817	2026-05-11 16:39:08.84996	\N	f
LM20251216101258-WV6O	162	Letícia	de Souza Siqueira rocha Marriel	Letícia de Souza Siqueira rocha Marriel 	1994-08-27	31	agosto	(27) 9 9862-7566	F	\N	Casado(a)	JOSE FELIPE MARRIEL DA PAIXAO	Esposo 	Rua Zuleica Siqueira Pádua 	Sn	Ribeira	Viana	ES	29132-702	t	t	Ativo	f	f	30-44	f	Sem Grupo	8	2025-12-16 10:12:58.285844	2026-05-11 16:39:08.911179	\N	f
LS20251104091155-EP7H	146	Lucas	Ferreira Sperandio	Lucas Ferreira Sperandio 	2021-03-02	5	março	(27) 9 9796-9899	M	\N	Solteiro(a)	\N	Filho	Otávio Cardoso de Alcântara 	67	Morada de santa fé	Cariacica	ES	29143-560	f	f	Ativo	f	f	3-5	f	Sem Grupo	3	2025-11-04 09:11:55.590089	2026-05-11 16:39:08.264595	/avatars/LS20251104091155-EP7H.jpg	f
JS20251208160023-SG4T	157	José	clenilson Brito dos Santos	José clenilson Brito dos Santos 	1983-10-11	42	outubro	(27) 9 9742-6794	M	\N	\N	\N	Milena régia Brito dos santos ( irmã )	Itamarati 	111	Itapemirim	Cariacica	ES	\N	t	t	Ativo	f	f	30-44	f	Sem Grupo	10	2025-12-08 16:00:23.350722	2026-05-11 16:39:08.742907	\N	f
KS20251104091151-EJ6L	68	Karoline	Marianelli de Souza	Karoline Marianelli de Souza 	1995-08-10	30	agosto	(27) 9 9867-5533	F	\N	Solteiro(a)	\N	\N	Cruzadas 	13	Vila Palestina	Cariacica	ES	29145-820	t	f	Desligado	f	f	30-44	f	Sem Grupo	8	2025-11-04 09:11:51.113067	2026-05-11 16:39:04.732472	\N	f
KQ20251104091151-GR8Z	69	Kesya	pereira de oliveira lira Queiroz	Kesya pereira de oliveira lira Queiroz 	1998-12-04	27	dezembro	(27) 9 8879-0012	F			Luiz Fernando Silva Queiroz lira 	Esposa 	São Paulo dos apóstolos 	182	Tucum	Cariacica	ES	29152-395	t	t	Ativo	f	f	18-29	f	Sem Grupo	12	2025-11-04 09:11:51.173178	2026-05-11 16:39:04.787456	/avatars/KQ20251104091151-GR8Z.jpg	f
SD20251104091154-QV5I	130	Sidnei	nogueira dias	Sidnei nogueira dias	1982-02-14	44	fevereiro	(27) 9 9750-7686	M	\N	Casado(a)	Bruna Will monteiro costa dias 	\N	Abílio pontini 	145	São Geraldo 2	Cariacica	ES	29146-805	t	t	Ativo	f	f	30-44	f	Sem Grupo	2	2025-11-04 09:11:54.531629	2026-05-11 16:39:07.573746	/avatars/SD20251104091154-QV5I.jpg	f
JG20251104091151-KQ5M	66	Júlio	César Sperandio Gouveia	Júlio César Sperandio Gouveia 	1978-10-03	47	outubro	(27) 9 9667-3447	M	\N	Casado(a)	Layane Ferreira de Morais 	\N	Otávio Cardoso de Alcântara 	67	Morada de santa fé	Cariacica	ES	29143-650	t	t	Ativo	f	f	45-59	f	Sem Grupo	10	2025-11-04 09:11:51.01949	2026-05-11 16:39:04.590525	\N	f
AL20251104091147-TG4G	11	Anderson	Presenza Lima	Anderson Presenza Lima	1990-10-27	35	outubro	(27) 9 9761-9680	M		Casado(a)	Rebeca Arantes Alves Presenza 	\N	São João 	38bf	Santo André	Cariacica	ES	29144-766	t	t	Ativo	f	f	30-44	f	Sem Grupo	10	2025-11-04 09:11:47.971069	2026-05-11 16:39:02.360404	\N	f
UM20251104091155-CS4X	137	Ubiranel	da Silveira Mota	Ubiranel da Silveira Mota	1981-09-14	44	setembro	(27) 9 9835-1035	M	Universal 	Casado(a)	Neudimar de oliveira mota	\N	Evaristo canal 	52	Ipanema	Viana	ES	29134-513	t	t	Ativo	f	f	30-44	f	Sem Grupo	9	2025-11-04 09:11:55.147791	2026-05-11 16:39:07.878931	/avatars/UM20251104091155-CS4X.jpg	f
LN20251104091151-OM3X	81	Levindo	Lucas da Cruz Neto	Levindo Lucas da Cruz Neto	1961-08-26	64	agosto	(27) 9 9606-5024	M	\N	Casado(a)	Lindalva de Castro Pereira da Cruz 	\N	Avenida Glauber Rocha 	109	Morada de santa fé	Cariacica	ES	29143-732	t	t	Ativo	f	f	60+	f	Sem Grupo	8	2025-11-04 09:11:51.809697	2026-05-11 16:39:05.450198	\N	f
FF20251104091149-TN5R	44	Fábio	Nunes Ferreira	Fábio Nunes Ferreira 	1977-11-14	48	novembro	(27) 9 9916-8641	M		Casado(a)	Scheila A. Torezani Ferreira 	\N	Da comunidade 	255	Rosa da Penha	Cariacica	ES	29143-430	t	t	Ativo	f	t	45-59	f	Sem Grupo	11	2025-11-04 09:11:49.807953	2026-05-11 16:39:03.710673	/avatars/FF20251104091149-TN5R.jpg	f
LL20251104091151-RR0Y	71	Laís	Martins Monteiro Lopes	Laís Martins Monteiro Lopes	1992-12-31	33	dezembro	(27) 9 9862-6144	F		Casado(a)	Diego Lopes	\N	Boa Vista	509	São Benedito	Cariacica	ES	29145-334	t	t	Ativo	f	t	30-44	f	Sem Grupo	12	2025-11-04 09:11:51.281016	2026-05-11 16:39:04.893727	/avatars/LL20251104091151-RR0Y.jpg	f
LR20251104091152-DF9S	85	Lucas	Amado Dos Reis	Lucas Amado Dos Reis	2009-02-15	17	fevereiro	(27) 9 9624-6871	M	\N	Solteiro(a)	\N	Gilmar José e Geovana De Souza	São Benedito 	48	Cruzeiro Do Sul	Cariacica	ES	29144-040	f	f	Desligado	f	f	12-17	f	Sem Grupo	2	2025-11-04 09:11:52.009332	2026-05-11 16:39:05.680072	\N	f
RL20251104091153-OI3H	121	Richardison	Silva Lopes	Richardison Silva Lopes 	1996-04-08	30	abril	(27) 9 9773-7276	M	\N	Casado(a)	Larissa Theodoro da Silva 	\N	Itaguaçu 	35	Morada de Santa Fé	Cariacica	ES	29143-666	t	t	Ativo	f	t	18-29	f	Sem Grupo	4	2025-11-04 09:11:53.889765	2026-05-11 16:39:07.159451	/avatars/RL20251104091153-OI3H.jpg	f
MM20251104091152-KX1R	101	Matheus	Henrique de Souza Moreira	Matheus Henrique de Souza Moreira 	1994-07-09	31	julho	(27) 9 9224-6707	M	\N	Casado(a)	Thayná de Souza Dutra 	\N	Avenida Espirito Santo 	1035	Jardim Campo Grande	Cariacica	ES	29141-459	t	f	Ativo	f	f	30-44	f	Sem Grupo	7	2025-11-04 09:11:52.865155	2026-05-11 16:39:06.3566	\N	f
SR20251104111353-MX5P	148	Sofia	de Oliveira Reis	Sofia de Oliveira Reis 	2024-11-19	1	novembro	(27) 99740-4499	F		Solteiro(a)	\N	Filha	Rua porto seguro 	216	Tiradentes	Cariacica	ES	29143-508	f	f	Ativo	f	f	0-2	f	Sem Grupo	11	2025-11-04 11:13:53.387292	2026-05-11 16:39:08.355739	/avatars/SR20251104111353-MX5P.jpg	f
LC20251104091151-BB7Z	70	Lais	Maria Pereira da Cruz	Lais Maria Pereira da Cruz 	2009-12-30	16	dezembro	(27) 9 9656-9535	F		Solteiro(a)	\N	Lindalva de Castro Pereira da Cruz 	Av Glauber Rocha 	109	Morada de santa fé	Cariacica	ES	29143-732	t	t	Ativo	f	f	12-17	f	Sem Grupo	12	2025-11-04 09:11:51.234578	2026-05-11 16:39:04.83393	/avatars/LC20251104091151-BB7Z.jpg	f
GA20251104091150-XJ7W	53	Guilherme	da Silva Alves	Guilherme da Silva Alves 	2016-07-13	9	julho	(27) 9 9654-7612	M	\N	Solteiro(a)	\N	Lorranhe da Silva mãe 	Independência 	466	Cruzeiro do Sul	Cariacica	ES	29144-060	f	f	Ativo	f	f	6-11	f	Sem Grupo	7	2025-11-04 09:11:50.338317	2026-05-11 16:39:04.047011	\N	f
PR20251104091153-BJ8E	114	Pedro	Marcos Rolim	Pedro Marcos Rolim 	1968-01-02	58	janeiro	(27) 9 9863-8921	M	\N	Casado(a)	Marli do Carmo Da Silva Rolim	\N	Nossa Senhora Aparecida 	37	São Geraldo 1	Cariacica	ES	29146-653	t	t	Ativo	f	f	45-59	f	Sem Grupo	1	2025-11-04 09:11:53.502582	2026-05-11 16:39:06.864261	/avatars/PR20251104091153-BJ8E.jpg	f
RN20251104091154-ZU5H	125	Rondiney	Nascimento	Rondiney Nascimento	1984-02-24	42	fevereiro	(27) 9 9690-3414	M	apt 302	Casado(a)	Miria Alves da Silva Nascimento 	\N	Ametista	25	São Geraldo 1	Cariacica	ES	29146-677	f	f	Ativo	f	f	30-44	f	Sem Grupo	2	2025-11-04 09:11:54.11075	2026-05-11 16:39:07.357275	/avatars/RN20251104091154-ZU5H.jpg	f
CS20251104091148-YB6U	26	CHRISTOPHER	ASAFE CRUZ DE SOUSA	CHRISTOPHER ASAFE CRUZ DE SOUSA	2011-01-24	15	janeiro	(27) 9 9644-9579	M	\N	Solteiro(a)	\N	ADELIDIA DE AZEVEDO CRUZ 	BOM PASTOR 	39	Campo Grande	Cariacica	ES	29146-060	t	t	Ativo	f	f	12-17	f	Sem Grupo	1	2025-11-04 09:11:48.934034	2026-05-11 16:39:03.011735	/avatars/CS20251104091148-YB6U.jpg	f
LF20251104091151-ED2U	79	Leonardo	Adame Freire	Leonardo Adame Freire 	1984-10-12	41	outubro	(27) 9 9509-4880	M	\N	Casado(a)	Maria Alda Alves de Souza 	\N	Dos Jacarandá 	20 B	Parque gramado	Cariacica	ES	29143-185	t	t	Ativo	f	f	30-44	f	Sem Grupo	10	2025-11-04 09:11:51.712899	2026-05-11 16:39:05.343383	\N	f
VS20251104091155-GB6F	141	VITOR	PINTO DA SILVA	VITOR PINTO DA SILVA	2007-05-25	18	maio	(27) 9 9576-9355	M	\N	Solteiro(a)	\N	EDERSON FLAVIO DA SILVA E LETÍCIA CALLOT PINTO DA SILVA	Itabira 	59	São Geraldo 2	Cariacica	ES	29146-840	t	t	Ativo	f	f	18-29	f	Sem Grupo	5	2025-11-04 09:11:55.33761	2026-05-11 16:39:08.064835	/avatars/VS20251104091155-GB6F.jpg	f
TF20251104091155-XH6P	136	Tiago	Dias Quaresma França	Tiago Dias Quaresma França 	2004-01-04	22	janeiro	(27) 9 9730-9316	M	\N	Casado(a)	Luisa Cassiano Borges Quaresma 	\N	Rua romana de jesus	85	Morada de santa fé	Cariacica	ES	29143-725	t	t	Ativo	f	f	18-29	f	Sem Grupo	1	2025-11-04 09:11:55.091107	2026-05-11 16:39:07.848453	/avatars/TF20251104091155-XH6P.jpg	f
KM20251104091151-JS6G	67	Kalebe	Henrique Souza Matos Moura	Kalebe Henrique Souza Matos Moura 	2015-12-20	10	dezembro	(27) 9 9756-6031	M	\N	Solteiro(a)	\N	Bruna Luiza Souza Silva de Jesus 	São Benedito 	48	Cruzeiro do Sul	Cariacica	ES	29144-040	t	t	Desligado	f	f	6-11	f	Sem Grupo	12	2025-11-04 09:11:51.062782	2026-05-11 16:39:04.661205	\N	f
MP20251104091153-MM1X	109	Miriam	da Rocha Pina	Miriam da Rocha Pina 	1988-10-07	37	outubro	(27) 9 9626-8387	F	Mudar para batizado	Casado(a)	Juliano Lovatti Ramos 	Esposo 	Rua São Luiz 	230	Itanguá	Cariacica	ES	29149-771	t	t	Ativo	f	f	30-44	f	Sem Grupo	10	2025-11-04 09:11:53.253272	2026-05-11 16:39:06.6319	\N	f
RS20251104091153-QX8M	117	Rafaella	Pereira Soares	Rafaella Pereira Soares	1989-06-25	36	junho	(27) 9 9523-9761	F	\N	Casado(a)	Mayk Helthon Lima Herzog	\N	São João	42	Santo André	Cariacica	ES	29144-766	t	t	Ativo	f	f	30-44	f	Sem Grupo	6	2025-11-04 09:11:53.675004	2026-05-11 16:39:07.002882	\N	f
MR20251104091152-EJ8T	95	Maria	Helena Rocha	Maria Helena Rocha	1976-01-15	50	janeiro	(27) 9 8842-7097	F	Data de registro 15/04/1976 / Divorciada	Solteiro(a)	\N	\N	Efigenio coelho 	64	Ipanema	Viana	ES	29134-044	t	t	Ativo	f	f	45-59	f	Sem Grupo	1	2025-11-04 09:11:52.581774	2026-05-11 16:39:06.078705	/avatars/MR20251104091152-EJ8T.jpg	f
RS20251104091153-TS0E	118	Raquel	lima dos santos	Raquel lima dos santos 	1998-02-14	28	fevereiro	(27) 9 8882-4139	F	\N	Solteiro(a)	\N	\N	Horizonte feliz 	43	Campina grande	Cariacica	ES	29144-306	t	t	Ativo	f	f	18-29	f	Sem Grupo	2	2025-11-04 09:11:53.725353	2026-05-11 16:39:07.04996	/avatars/RS20251104091153-TS0E.jpg	f
TC20251104091154-OT5H	133	Thamyres	Coelho Cardoso	Thamyres Coelho Cardoso 	2001-05-24	24	maio	(27) 9 9807-2540	F	\N	Casado(a)	Gabriel Dondoni Alves	\N	Guarapari	19	Vista dourada	Cariacica	ES	29158-652	t	f	Desligado	f	f	18-29	f	Sem Grupo	5	2025-11-04 09:11:54.796408	2026-05-11 16:39:07.711817	\N	f
TD20251104091154-FJ2M	134	Thayná	de Souza Dutra	Thayná de Souza Dutra	1996-03-04	30	março	(27) 9 9907-3362	F	\N	Casado(a)	Matheus Henrique de Souza Moreira	\N	Avenida Espirito Santo	1035	Jardim Campo Grande	Cariacica	ES	29141-459	t	f	Ativo	f	f	30-44	f	Sem Grupo	3	2025-11-04 09:11:54.919198	2026-05-11 16:39:07.757209	/avatars/TD20251104091154-FJ2M.jpg	f
BN20251104091148-MM7Y	16	Benício	Alves Nascimento	Benício Alves Nascimento	2023-07-11	2	julho	(27) 9 9531-0232	M	apt 302	Solteiro(a)	\N	Miria Alves da Silva Nascimento	Ametista	25	São Geraldo 1	Cariacica	ES	29146-680	f	f	Ativo	f	f	0-2	f	Sem Grupo	7	2025-11-04 09:11:48.358057	2026-05-11 16:39:02.594582	/avatars/BN20251104091148-MM7Y.jpg	f
VC20251104091155-CH5U	139	Verônica	da Silva Alves Claro	Verônica da Silva Alves Claro 	1991-06-11	34	junho	(27) 9 8862-8318	F	\N	Casado(a)	Alberto Claro Júnior 	\N	Ressurreição 	209	Vila Palestina	Cariacica	ES	29145-675	t	f	Desligado	f	f	30-44	f	Sem Grupo	6	2025-11-04 09:11:55.23657	2026-05-11 16:39:07.973867	\N	f
LS20251104091155-GP5Y	145	Luana	Ferreira Sperandio	Luana Ferreira Sperandio 	2024-11-24	1	novembro	(27) 9 9796-9899	F		Solteiro(a)	\N	Filha	Otávio Cardoso de Alcântara 	67	Morada de santa fé	Cariacica	ES	29143-560	f	f	Ativo	f	f	0-2	f	Sem Grupo	11	2025-11-04 09:11:55.548754	2026-05-11 16:39:08.22011	/avatars/LS20251104091155-GP5Y.jpg	f
SR20251104091154-GM0B	131	Suelen	vieira de rezende	Suelen vieira de rezende 	2001-05-31	24	maio	27988356879	F	\N	Casado(a)	Daniel Santiago Neris 	\N	12	102	Nova Rosa da Penha 1	Cariacica	ES	29157410	t	f	Ativo	f	f	18-29	f	Sem Grupo	5	2025-11-04 09:11:54.587862	2026-05-11 16:40:06.613233	\N	f
MR20251104091152-UV3V	99	Marli	do Carmo da Silva Rolim	Marli do Carmo da Silva Rolim	1971-07-02	54	julho	(27) 9 9743-4854	F	\N	Casado(a)	Pedro Marcos Rolim	\N	Nossa Senhora Aparecida 	37	São Geraldo 1	Cariacica	ES	29146-653	t	t	Ativo	f	f	45-59	f	Sem Grupo	7	2025-11-04 09:11:52.770284	2026-05-11 16:39:06.263278	\N	f
LL20251104091151-JF5Y	72	Lara	Pereira Lima	Lara Pereira Lima	2018-09-13	7	setembro	(27) 9 9523-9761	F	\N	Solteiro(a)	\N	Rafaella Pereira Soares 	São João	42	Santo André	Cariacica	ES	29144-766	f	f	Ativo	f	f	6-11	f	Sem Grupo	9	2025-11-04 09:11:51.333665	2026-05-11 16:39:04.956512	\N	f
RC20251104091153-NH3R	120	Regina	Célia Martins Bastos e Cruz	Regina Célia Martins Bastos e Cruz	1962-10-31	63	outubro	(27) 9 9806-0509	F	numero da casa 9, (613 pelo GPS)	Viúvo(a)	\N	\N	Avenida Costa Brandão	9	São Geraldo 2	Cariacica	ES	29146-835	t	t	Ativo	f	f	60+	f	Sem Grupo	10	2025-11-04 09:11:53.827324	2026-05-11 16:39:07.126387	\N	f
LP20251104091155-DL9U	147	Liz	Ferreira Paulino	Liz Ferreira Paulino 	2022-11-03	3	novembro	(27) 9 9919-7541	F		Solteiro(a)	\N	Filha	Porto seguro 	237	Tiradentes	Cariacica	ES	29143-508 	f	f	Ativo	f	f	3-5	f	Sem Grupo	11	2025-11-04 09:11:55.641739	2026-05-11 16:39:08.310062	/avatars/LP20251104091155-DL9U.jpeg	f
LL20251104091151-MT9R	77	Lavínia	Monteiro Lopes	Lavínia Monteiro Lopes	2021-07-06	4	julho	(27) 9 9862-6144	F	\N	Solteiro(a)	\N	Diego e Lais Lopes	Boa Vista	509	São Benedito	Cariacica	ES	29145-334	f	f	Ativo	f	f	3-5	f	Sem Grupo	7	2025-11-04 09:11:51.622118	2026-05-11 16:39:05.233567	\N	f
TB20251104091155-BG1G	135	Thiffany	Fernandes de Brito	Thiffany Fernandes de Brito 	1999-02-17	27	fevereiro	(27) 9 9574-6717	F	\N	Casado(a)	Protazio Rezende Carvalho	\N	Serra da Mantiqueira 	66	Nova Bethânia	Viana	ES	29138-189	t	t	Ativo	f	f	18-29	f	Sem Grupo	2	2025-11-04 09:11:55.006175	2026-05-11 16:39:07.80253	/avatars/TB20251104091155-BG1G.jpg	f
MA20251104091152-TQ9U	98	Marilza	Oliveira da Costa Almeida	Marilza Oliveira da Costa Almeida 	1971-04-09	55	abril	27996179308	F	\N	Casado(a)	Beraldino de Almeida Filho	\N	Evaristo canal 	63	Ipanema	Viana	ES		t	f	Ativo	f	f	45-59	f	Sem Grupo	4	2025-11-04 09:11:52.719247	2026-05-11 16:40:38.431718	\N	f
AM20251104091147-HP5I	10	Ana	Luiza Souza Matos Moura	Ana Luiza Souza Matos Moura 	2014-05-26	11	maio	(27) 9 9756-6031	F	\N	Solteiro(a)	\N	Bruna Luiza Souza Silva de Jesus 	São Benedito 	48	Cruzeiro do Sul	Cariacica	ES	29144-040	t	t	Desligado	f	f	6-11	f	Sem Grupo	5	2025-11-04 09:11:47.915051	2026-05-11 16:39:02.31314	\N	f
MC20251104091152-MB4O	93	Maria	Clara Mendonça Colonetti	Maria Clara Mendonça Colonetti 	2006-07-03	19	julho	(27) 9 9997-2115	F	\N	Solteiro(a)	\N	\N	Claricio Alves Ribeiro	100	Itanguá	Cariacica	ES	29149-800 	t	f	Desligado	f	f	18-29	f	Sem Grupo	7	2025-11-04 09:11:52.45714	2026-05-11 16:39:06.000289	\N	f
MH20251104091152-GJ6Q	103	Mayra	Da silva rolim herpet	Mayra Da silva rolim herpet	1997-01-15	29	janeiro	(27) 9 9917-1122	F	\N	Casado(a)	Geovanny herpet Pereira 	\N	Aparecida	37	São Geraldo	Cariacica	ES	29146-653	t	t	Ativo	f	f	18-29	f	Sem Grupo	1	2025-11-04 09:11:52.954537	2026-05-11 16:39:06.417557	/avatars/MH20251104091152-GJ6Q.jpg	f
BV20251104091148-CT9M	19	Bruna	Lorrani Rocha Mousinho Viana	Bruna Lorrani Rocha Mousinho Viana 	1998-05-25	27	maio	(27) 9 8810-5762	F	\N	Casado(a)	Guilherme dos Passos Siqueira Viana 	\N	Ametista 	34	São Geraldo 1	Cariacica	ES	29146-677	t	t	Ativo	f	f	18-29	f	Sem Grupo	5	2025-11-04 09:11:48.51238	2026-05-11 16:39:02.718766	/avatars/BV20251104091148-CT9M.jpg	f
AC20251104091147-CY2X	3	ADELIDIA	DE AZEVEDO CRUZ	ADELIDIA DE AZEVEDO CRUZ	1974-09-27	51	setembro	(27) 9 9703-1407	F		Casado(a)	CARLOS WEBERSON DE SOUSA	\N	BOM PASTOR	39	Campo Grande	Cariacica	ES	29146-060	t	t	Ativo	f	t	45-59	f	Sem Grupo	9	2025-11-04 09:11:47.542229	2026-05-11 16:39:02.018757	\N	f
AL20251104091147-WH0I	8	Amanda	Ronquetti da Silva Lima	Amanda Ronquetti da Silva Lima 	1991-05-10	35	maio	(27) 9 9762-9765	F	\N	Casado(a)	Gildazio Lima dos Santos	Edilene Ronquetti 	O	06	Campo verde	Viana	ES	29138-445	t	t	Ativo	f	f	30-44	f	Sem Grupo	5	2025-11-04 09:11:47.801274	2026-05-11 16:39:02.218443	/avatars/AL20251104091147-WH0I.jpg	f
RR20251104091154-MQ6T	124	Roberta	Ita rabi	Roberta Ita rabi	1978-08-30	47	agosto	(27) 9 8871-3380	F	\N	\N	\N	\N	Rua mina gerais 	Sn	Ipanema	Viana	ES	\N	t	t	Ativo	f	f	45-59	f	Sem Grupo	8	2025-11-04 09:11:54.052381	2026-05-11 16:39:07.310039	\N	f
BP20251104091148-SE8A	18	Bernardo	Tavares Pereira	Bernardo Tavares Pereira 	2003-08-27	22	agosto	(27) 9 9695-2399	M	\N	Solteiro(a)	\N	\N	Monte Calvário 	3	Vila Palestina	Cariacica	ES	29145-760	t	t	Ativo	f	f	18-29	f	Sem Grupo	8	2025-11-04 09:11:48.46663	2026-05-11 16:39:02.687867	\N	f
AL20251104091147-WM7I	1	ABNER	ABADIS LIMA	ABNER ABADIS LIMA	2022-01-02	4	janeiro	(27) 9 9529-8253	M		Solteiro(a)	\N	JILVANETE LIMA DOS SANTOS 	HORIZONTE FELIZ 	02	CAMPINA GRANDE	Cariacica	ES	29144-306	f	f	Ativo	f	f	3-5	f	Sem Grupo	1	2025-11-04 09:11:47.352005	2026-05-11 16:39:01.879457	/avatars/AL20251104091147-WM7I.jpg	f
BJ20251104091148-WJ7Y	20	Bruna	Luiza Souza Silva de Jesus	Bruna Luiza Souza Silva de Jesus 	1982-06-12	43	junho	(27) 9 9756-6031	F	\N	Casado(a)	Edilson Azevedo de Jesus 	\N	São Benedito 	48	Cruzeiro do Sul	Cariacica	ES	29144-040	t	t	Desligado	f	f	30-44	f	Sem Grupo	6	2025-11-04 09:11:48.574113	2026-05-11 16:39:02.759017	\N	f
AS20251104091147-AC1C	2	ADASSA	VALENTINA CRUZ DE SOUSA	ADASSA VALENTINA CRUZ DE SOUSA	2007-12-28	18	dezembro	(27) 9 9604-6516	F		Solteiro(a)	\N	ADELIDIA DE AZEVEDO CRUZ	BOM PASTOR	39	Campo Grande	Cariacica	ES	29146-060	t	t	Ativo	f	f	18-29	f	Sem Grupo	12	2025-11-04 09:11:47.477898	2026-05-11 16:39:01.972452	/avatars/AS20251104091147-AC1C.jpg	f
AJ20251104091147-MS4E	4	Alberto	Claro Júnior	Alberto Claro Júnior 	1979-05-29	46	maio	(27) 9 8805-8902	M	\N	Casado(a)	Verônica da Silva Alves Claro 	\N	Ressurreição 	209	Vila Palestina	Cariacica	ES	29145-675	t	f	Desligado	f	f	45-59	f	Sem Grupo	5	2025-11-04 09:11:47.583132	2026-05-11 16:39:02.063629	\N	f
AP20251104091147-SC8B	6	Alício	de Souza Pereira	Alício de Souza Pereira 	1960-12-26	65	dezembro	(27) 9 9813-1236	M		Casado(a)	Mara Lucia Tavares Pereira 	\N	Monte Calvário 	03	Vila Palestina	Cariacica	ES	29145-760	t	t	Ativo	f	f	60+	f	Sem Grupo	12	2025-11-04 09:11:47.698759	2026-05-11 16:39:02.142044	/avatars/AP20251104091147-SC8B.jpg	f
AS20251104091147-EE8N	7	Amanda	de Oliveira Sousa	Amanda de Oliveira Sousa 	1998-04-10	28	abril	(27) 9 9740-4499	F	\N	\N	Layson Paulo dos Reis 	\N	Rua Porto seguro 	216	Tiradentes	Cariacica	ES	29143-508	t	t	Ativo	f	f	18-29	f	Sem Grupo	4	2025-11-04 09:11:47.742681	2026-05-11 16:39:02.174558	/avatars/AS20251104091147-EE8N.jpg	f
AP20251104091148-XV7J	12	Anny	Nicolly de Souza Paixao	Anny Nicolly de Souza Paixao 	2008-03-29	18	março	(27) 9 9837-9768	F	\N	Solteiro(a)	\N	Lilian de Souza vieira e Willian de Oliveira Souza 	16	141	Nova Rosa da Penha 1	Cariacica	ES	29157-414	t	t	Ativo	f	f	12-17	f	Sem Grupo	3	2025-11-04 09:11:48.086452	2026-05-11 16:39:02.408931	/avatars/AP20251104091148-XV7J.jpg	f
AN20251104091148-NK6E	14	Antônio	Francisco do Nascimento	Antônio Francisco do Nascimento 	1952-03-29	74	março	(27) 9 9944-1318	M	\N	Casado(a)	Terezinha Fontes	\N	Esmeralda	159	São Geraldo 1	Cariacica	ES	29146-675	t	t	Ativo	f	f	60+	f	Sem Grupo	3	2025-11-04 09:11:48.248526	2026-05-11 16:39:02.500997	\N	f
BD20251104091148-IL9S	21	Bruna	Will monteiro costa dias	Bruna Will monteiro costa dias 	1987-05-28	38	maio	(27) 9 9836-1927	F	\N	Casado(a)	SIDNEI NOGUEIRA DIAS	\N	Abílio pontini	145	São Geraldo 2	Cariacica	ES	29146-805	t	t	Ativo	f	f	30-44	f	Sem Grupo	5	2025-11-04 09:11:48.652426	2026-05-11 16:39:02.811981	/avatars/BD20251104091148-IL9S.jpg	f
CS20251104091148-FN3X	22	CARLOS	WEBERSON DE SOUSA	CARLOS WEBERSON DE SOUSA	1971-09-19	54	setembro	(27) 9 9947-0220	M		Casado(a)	ADELIDIA DE AZEVEDO CRUZ	\N	BOM PASTOR	39	Campo Grande	Cariacica	ES	29146-060	t	t	Ativo	f	t	45-59	f	Sem Grupo	9	2025-11-04 09:11:48.730331	2026-05-11 16:39:02.857716	\N	f
CP20251104091148-JZ1B	23	Cecília	de Andrade Pereira	Cecília de Andrade Pereira 	2020-02-19	6	fevereiro	(27) 9 9963-2279	F	\N	Solteiro(a)	\N	Crislayne (Mãe) Christian (Pai)	Pavão 	27	São Conrado	Cariacica	ES	29141-195	f	f	Ativo	f	f	6-11	f	Sem Grupo	2	2025-11-04 09:11:48.796253	2026-05-11 16:39:02.905926	/avatars/CP20251104091148-JZ1B.jpg	f
AA20251104091148-NF4E	15	Ayrton	Costa de Almeida	Ayrton Costa de Almeida	1994-08-30	31	agosto	(27) 9 9766-5900	M		Casado(a)	Veruska Pinto Mouzinho Almeida	\N	Otávio Cardoso de Alcântara 	40	Santa Fe	Cariacica	ES	29143-650	t	t	Ativo	f	t	30-44	f	Sem Grupo	8	2025-11-04 09:11:48.305351	2026-05-11 16:39:02.547984	\N	f
CP20251104091148-IA2B	24	Christian	da Silva Pereira	Christian da Silva Pereira	1998-03-27	28	março	(27) 9 9811-4127	M	\N	Casado(a)	Crislayne Pereira	\N	Pavão 	27	São Conrado	Cariacica	ES	29141-195	t	t	Ativo	f	f	18-29	f	Sem Grupo	3	2025-11-04 09:11:48.841642	2026-05-11 16:39:02.950313	/avatars/CP20251104091148-IA2B.jpg	f
CS20251104091148-HO1T	27	Cleber	de jesus Sepulcro	Cleber de jesus Sepulcro 	1978-05-26	47	maio	(27) 9 9851-9473	M	\N	Casado(a)	Rina Mendonça Gomes 	\N	Claricio Alves Ribeiro 	100	Itanguá	Cariacica	ES	29149-800	t	f	Desligado	f	f	45-59	f	Sem Grupo	5	2025-11-04 09:11:48.976239	2026-05-11 16:39:03.043519	\N	f
ER20251104091149-US4G	34	Edilene	Ronquetti	Edilene Ronquetti 	1960-09-18	65	setembro	(27) 9 9954-9551	F	\N	Solteiro(a)	\N	\N	Odonia da Costa Machado Toledo	311	Santa Barbara	Cariacica	ES	29.144 375	t	t	Ativo	f	f	60+	f	Sem Grupo	9	2025-11-04 09:11:49.311436	2026-05-11 16:39:03.290724	\N	f
EP20251104091149-JP5T	36	Elita	da Penha Pego Pereira	Elita da Penha Pego Pereira 	1957-09-04	68	setembro	(27) 9 9255-0419	F	\N	Casado(a)	Jair alves Pereira 	\N	São João  do Acre	68	Vila palestina	Cariacica	ES	29145-790	t	f	Desligado	f	f	60+	f	Sem Grupo	9	2025-11-04 09:11:49.418775	2026-05-11 16:39:03.37219	\N	f
EM20251104091149-VC7E	37	Eloáh	de Souza Moreira	Eloáh de Souza Moreira 	2021-10-02	4	outubro	(27) 9 9907-3362	F	\N	Solteiro(a)	\N	Thayná de Souza Dutra e Matheus Henrique de Souza Moreira 	Avenida Espirito Santo 	1035	Jardim Campo Grande	Cariacica	ES	29141-459	f	f	Ativo	f	f	3-5	f	Sem Grupo	10	2025-11-04 09:11:49.4689	2026-05-11 16:39:03.416121	\N	f
EN20251104091149-JE9V	39	Emanuela	Souza Silva Novais	Emanuela Souza Silva Novais 	2007-04-14	19	abril	(27) 9 9756-6031	F	\N	Solteiro(a)	\N	Bruna Luiza Souza Silva de Jesus 	São Benedito 	48	Cruzeiro do Sul	Cariacica	ES	29144-040	f	f	Desligado	f	f	18-29	f	Sem Grupo	4	2025-11-04 09:11:49.561654	2026-05-11 16:39:03.493298	\N	f
LM20251104091151-XY5V	78	Layane	Ferreira de Morais	Layane Ferreira de Morais 	1993-11-12	32	novembro	(27) 9 9796-9899	F		Casado(a)	Júlio César Sperandio Gouveia 	\N	Otávio Cardoso de Alcântara 	67	Morada de santa fé	Cariacica	ES	29143-650	t	t	Ativo	f	f	30-44	f	Sem Grupo	11	2025-11-04 09:11:51.664911	2026-05-11 16:39:05.279646	/avatars/LM20251104091151-XY5V.jpg	f
MP20251104091152-QH7C	89	Manoela	Tavares Pereira	Manoela Tavares Pereira 	1997-12-17	28	dezembro	(27) 9 9634-9682	F		Solteiro(a)	\N	\N	Monte Calvário 	03	Vila Palestina	Cariacica	ES	29145-760	t	t	Ativo	f	t	18-29	f	Sem Grupo	12	2025-11-04 09:11:52.221717	2026-05-11 16:39:05.848169	/avatars/MP20251104091152-QH7C.jpg	f
PE20251125085909-JP4U	151	Patricio	santos evangelista	Patricio santos evangelista 	1988-07-20	37	julho	(27) 9 9247-8715	M		Casado(a)	Lohanna oliveira santos 	\N	Rua Sergipe 	1	Campina grande	Cariacica	ES	29144-418	t	t	Ativo	f	f	30-44	f	Sem Grupo	7	2025-11-25 08:59:09.113553	2026-05-11 16:39:08.479207	\N	f
BD20251104091148-OV4U	17	Bento	Honori Dondoni	Bento Honori Dondoni 	2024-01-25	2	janeiro	(27) 9 9807-2540	M	\N	Solteiro(a)	\N	Thamyres Coelho e Gabriel Dondoni	Guarapari 	19	Vista Dourada	Cariacica	ES	29158-652	f	f	Desligado	f	f	0-2	f	Sem Grupo	1	2025-11-04 09:11:48.422797	2026-05-11 16:39:02.644805	\N	f
LL20251127114644-VT6K	152	Laís	Pereira Lima	Laís Pereira Lima	2024-12-30	1	dezembro	(27) 9 9523-9761	F			\N	Filha	São João	42	Santo André	Cariacica	ES	29144-766	f	f	Ativo	f	f	0-2	f	Sem Grupo	12	2025-11-27 11:46:44.963971	2026-05-11 16:39:08.52435	/avatars/LL20251127114644-VT6K.jpg	f
AH20251127114645-WL4U	153	Adenizia	Ferreira de Oliveira Hoffmann	Adenizia Ferreira de Oliveira Hoffmann 	1958-05-12	67	maio	(27) 9 9843-0866	F			Falecido. Feliz Carlos Hoffmann 	\N	Sergipe 	1	Campina grande	Cariacica	ES	29144-416	t	t	Ativo	f	f	60+	f	Sem Grupo	5	2025-11-27 11:46:45.010302	2026-05-11 16:39:08.556779	\N	f
DN20251104091149-BV6Z	29	Daniel	Santiago Neris	Daniel Santiago Neris 	1999-08-01	26	agosto	(27) 9 8827-5109	M	\N	Casado(a)	Suelen viera de Rezende 	\N	12	102	Nova Rosa da Penha 1	Cariacica	ES	29157-410	f	f	Ativo	f	f	18-29	f	Sem Grupo	8	2025-11-04 09:11:49.06895	2026-05-11 16:39:03.118989	\N	f
DA20251104091149-UV3Q	30	Davi	de Lima Azevedo	Davi de Lima Azevedo 	2014-09-10	11	setembro	(27) 9 9896-5321	M	\N	Solteiro(a)	\N	Joseph das Neves Azevedo 	Bela Vista	15	Arlindo Vilaschi	Viana	ES	29136-180	t	t	Ativo	f	f	6-11	f	Sem Grupo	9	2025-11-04 09:11:49.112835	2026-05-11 16:39:03.15009	\N	f
DL20251104091149-FZ4U	32	Diego	Sarmento Lopes	Diego Sarmento Lopes	1988-06-17	37	junho	(27) 9 9997-6075	M	\N	Casado(a)	Laís Lopes	\N	Boa Vista	509	São Benedito	Cariacica	ES	29145-334	t	t	Ativo	f	t	30-44	f	Sem Grupo	6	2025-11-04 09:11:49.212209	2026-05-11 16:39:03.212997	/avatars/DL20251104091149-FZ4U.jpg	f
FS20251104091149-FS7V	45	Flávio	Siqueira	Flávio Siqueira 	1973-10-06	52	outubro	(27) 9 9874-1382	M	\N	Casado(a)	Joscileia Ferreira 	\N	Porto Seguro 	206	Tiradentes	Cariacica	ES	29143-508 	t	t	Ativo	f	f	45-59	f	Sem Grupo	10	2025-11-04 09:11:49.860253	2026-05-11 16:39:03.754902	\N	f
GS20251104091149-CH6S	47	Gabrielle	Rocha Da Silva	Gabrielle Rocha Da Silva	2009-03-14	17	março	(27) 9 9648-6318	F	\N	Solteiro(a)	\N	Maria Helena Rocha	Elizabeth 2	50	Universal	Viana	ES	29134-526	t	t	Ativo	f	f	12-17	f	Sem Grupo	3	2025-11-04 09:11:49.951169	2026-05-11 16:39:03.848141	/avatars/GS20251104091149-CH6S.jpg	f
AS20251104091147-LV7T	5	Aldeny	Ferreira de Oliveira Sousa	Aldeny Ferreira de Oliveira Sousa 	1971-11-16	54	novembro	(27) 998738834	F			Maciel de Araújo Sousa	\N	Porto Seguro 	216	Tiradentes	Cariacica	ES	29143-508	t	t	Ativo	f	f	45-59	f	Sem Grupo	11	2025-11-04 09:11:47.639411	2026-05-11 16:39:02.097208	/avatars/AS20251104091147-LV7T.jpg	f
GC20251104091149-XQ8W	48	GETÚLIO	SILVA CORREA	GETÚLIO SILVA CORREA	1951-09-18	74	setembro	(27) 9 9937-0112	M			\N	\N	AV. PALESTINA	03	VILA PALESTINA	Cariacica	ES		t	t	Ativo	f	f	60+	f	Sem Grupo	9	2025-11-04 09:11:49.999099	2026-05-11 16:39:03.878531	\N	f
GS20251104091150-TW9Y	49	Gildazio	lima dos santos	Gildazio lima dos santos 	1994-01-02	32	janeiro	(27) 9 8103-7306	M	\N	Casado(a)	Amanda Ronquetti	\N	O	06	Campo verde	Viana	ES	29138-445	t	t	Ativo	f	f	30-44	f	Sem Grupo	1	2025-11-04 09:11:50.062663	2026-05-11 16:39:03.909832	/avatars/GS20251104091150-TW9Y.jpg	f
CP20251104091149-HQ6B	28	Crislayne	de Souza Andrade Pereira	Crislayne de Souza Andrade Pereira 	1999-07-12	26	julho	(27) 9 9963-2279	F	\N	Casado(a)	Christian da Silva Pereira 	\N	Pavão 	27	São Conrado	Cariacica	ES	29141-195	t	t	Ativo	f	f	18-29	f	Sem Grupo	7	2025-11-04 09:11:49.025348	2026-05-11 16:39:03.087072	/avatars/CP20251104091149-HQ6B.jpg	f
GF20251104091150-DS7N	50	Gilmara	Anselmo Fernandes	Gilmara Anselmo Fernandes 	1978-04-15	48	abril	(27) 9 8146-6347	F	\N	\N	\N	\N	dos milagres	37	Vila Palestina	Cariacica	ES	\N	t	t	Ativo	f	f	45-59	f	Sem Grupo	4	2025-11-04 09:11:50.146541	2026-05-11 16:39:03.941845	\N	f
LB20251104091152-CL5U	86	Luisa	cassiano borges	Luisa cassiano borges 	2003-11-15	22	novembro	(27) 9 9574-2249	F		Casado(a)	Tiago Dias 	\N	Paulo dos apóstolos 	13	Tucum	Cariacica	ES	29152-395 	t	t	Ativo	f	f	18-29	f	Sem Grupo	11	2025-11-04 09:11:52.071821	2026-05-11 16:39:05.713977	/avatars/LB20251104091152-CL5U.jpg	f
LL20251104091152-CQ8W	87	Luiz	Fernando Silva Queiroz lira	Luiz Fernando Silva Queiroz lira 	1994-11-26	31	novembro	(27) 9 8800-0960	M			Kesya pereira lira de oliveira Queiroz	\N	São Paulo dos apóstolos 	182	Tucum	Cariacica	ES	29152-395	t	t	Ativo	f	f	30-44	f	Sem Grupo	11	2025-11-04 09:11:52.121516	2026-05-11 16:39:05.757805	/avatars/LL20251104091152-CQ8W.jpeg	f
SF20251104091154-TJ3O	126	Samuel	Torezani Ferreira	Samuel Torezani Ferreira 	2013-03-20	13	março	(27) 9 9616-2326	M	\N	Solteiro(a)	\N	Fábio Nunes Ferreira 	Da comunidade 	255	Rosa da Penha	Cariacica	ES	29143-430	t	t	Ativo	f	f	12-17	f	Sem Grupo	3	2025-11-04 09:11:54.166653	2026-05-11 16:39:07.404061	/avatars/SF20251104091154-TJ3O.jpg	f
ES20251104091149-BI2Z	33	EDERSON	FLÁVIO DA SILVA	EDERSON FLÁVIO DA SILVA	1980-08-07	45	agosto	(27) 9 8864-0283	M	\N	Casado(a)	LETÍCIA CALLOT PINTO DA SILVA	\N	Itabira	59	São Geraldo 2	Cariacica	ES	29146-840	t	t	Ativo	f	f	45-59	f	Sem Grupo	8	2025-11-04 09:11:49.257819	2026-05-11 16:39:03.246326	\N	f
EA20251104091149-DO3N	38	Emanuel	Mouzinho Almeida	Emanuel Mouzinho Almeida	2019-10-17	6	outubro	(27) 9 9722-6172	M	\N	Solteiro(a)	\N	Ayrton Costa de Almeida	Otávio Cardoso de Alcântara 	40	Santa Fe	Cariacica	ES	29143-650	f	f	Ativo	f	f	6-11	f	Sem Grupo	10	2025-11-04 09:11:49.513768	2026-05-11 16:39:03.446804	\N	f
EF20251104091149-FF6E	40	Emilia	Anselmo Fernandes	Emilia Anselmo Fernandes	1935-09-17	90	setembro	(27) 9 8146-6347	F	\N	\N	\N	\N	dos milagres	37	Vila Palestina	Cariacica	ES	\N	t	t	Ativo	f	f	60+	f	Sem Grupo	9	2025-11-04 09:11:49.607547	2026-05-11 16:39:03.538635	\N	f
ED20251104091149-NH2H	42	Evellyn	Will monteiro costa dias	Evellyn Will monteiro costa dias 	2014-05-28	11	maio	(27) 9 9836-1927	F	\N	Solteiro(a)	\N	Bruna Will 	Abílio pontini 	145	São Geraldo 2	Cariacica	ES	29246-805	t	t	Ativo	f	f	6-11	f	Sem Grupo	5	2025-11-04 09:11:49.719353	2026-05-11 16:39:03.599414	/avatars/ED20251104091149-NH2H.jpg	f
DM20251104091149-KM7C	31	Davi	Souza Matos Moura	Davi Souza Matos Moura 	2012-05-04	14	maio	(27) 9 9756-6031	M	\N	Solteiro(a)	\N	Bruna Luiza Souza Silva de Jesus 	São Benedito 	48	Cruzeiro do Sul	Cariacica	ES	29144-040	t	t	Desligado	f	f	12-17	f	Sem Grupo	5	2025-11-04 09:11:49.160277	2026-05-11 16:39:03.181684	\N	f
EP20251104091149-TZ1M	43	Evelyn	Santa Clara De Paula	Evelyn Santa Clara De Paula 	2018-12-01	7	dezembro	(27) 9 9622-5719	F		Solteiro(a)	\N	Erielton De paula Melo 	Das Papoulas	161	Santo André	Cariacica	ES	29144-657	f	f	Ativo	f	f	6-11	f	Sem Grupo	12	2025-11-04 09:11:49.765983	2026-05-11 16:39:03.647196	/avatars/EP20251104091149-TZ1M.jpg	f
GS20251104091150-BT6S	51	GLÊNIO	ABADIS DOS SANTOS	GLÊNIO ABADIS DOS SANTOS 	1980-12-10	45	dezembro	(27) 9 9782-6522	M		Casado(a)	JILVANETE LIMA DOS SANTOS 	\N	HORIZONTE FELIZ 	02	CAMPINA GRANDE	Cariacica	ES	29144-306	t	t	Ativo	f	t	45-59	f	Sem Grupo	12	2025-11-04 09:11:50.205158	2026-05-11 16:39:03.987329	/avatars/GS20251104091150-BT6S.jpg	f
GM20251104091150-RE4U	52	Grezieli	Rocha Mousinho	Grezieli Rocha Mousinho 	1999-09-10	26	setembro	(27) 9 9642-2970	F	\N	Casado(a)	Jhonatan de Souza Andrade 	\N	Crisólito 	18	São Geraldo 1	Cariacica	ES	29146-605	t	t	Ativo	f	t	18-29	f	Sem Grupo	9	2025-11-04 09:11:50.277183	2026-05-11 16:39:04.017308	\N	f
HC20251104091150-ST4D	55	Heitor	Fernandes da Cruz	Heitor Fernandes da Cruz 	2007-10-18	18	outubro	(27) 9 9251-6839	M	Namorado da Maria Clara	Solteiro(a)	\N	Andreia Fernandes Machado risso 	nossa senhora Aparecida 	83	São Geraldo 1	Cariacica	ES	29146-653	t	f	Desligado	f	f	18-29	f	Sem Grupo	10	2025-11-04 09:11:50.436097	2026-05-11 16:39:04.110086	\N	f
SP20251104091154-OA3Y	127	Schaiany	Pimentel Santa Clara de Paula	Schaiany Pimentel Santa Clara de Paula 	1993-07-02	32	julho	(27) 9 9664-0632	F		Casado(a)	Erielton De Paula Melo	\N	Das Papoulas 	161	Santo André	Cariacica	ES	29144-657	t	t	Ativo	f	t	30-44	f	Sem Grupo	7	2025-11-04 09:11:54.263762	2026-05-11 16:39:07.464076	/avatars/SP20251104091154-OA3Y.jpg	f
JB20251104091150-CR8X	58	Jean	Carlos Bergamini	Jean Carlos Bergamini 	1974-10-01	51	outubro	(27) 9 9903-6505	M	\N	Casado(a)	Maria José Bergamini 	\N	Itabira 	38	São Geraldo 2	Cariacica	ES	29146-840	t	t	Ativo	f	f	45-59	f	Sem Grupo	10	2025-11-04 09:11:50.615339	2026-05-11 16:39:04.232637	\N	f
JA20251104091150-OL3F	59	Jhonatan	de Souza Andrade	Jhonatan de Souza Andrade	1993-04-29	33	abril	(27) 9 9965-3596	M	\N	Casado(a)	Grezieli Rocha Mousinho Andrade	\N	Crisólito 	18	São Geraldo 1	Cariacica	ES	29146-605	t	t	Ativo	f	f	30-44	f	Sem Grupo	4	2025-11-04 09:11:50.664418	2026-05-11 16:39:04.278409	/avatars/JA20251104091150-OL3F.jpg	f
JS20251104091150-BA6P	60	JILVANETE	LIMA DOS SANTOS	JILVANETE LIMA DOS SANTOS 	1985-12-07	40	dezembro	(27) 9 9529-8253	F		Casado(a)	GLÊNIO ABADIS DOS SANTOS 	\N	Orizonte feliz	02	Campina Grande	Cariacica	ES	29144-306	t	t	Ativo	f	f	30-44	f	Sem Grupo	12	2025-11-04 09:11:50.726338	2026-05-11 16:39:04.309527	/avatars/JS20251104091150-BA6P.jpg	f
JM20251104091150-IT2W	61	João	Pedro de Oliveira Mota	João Pedro de Oliveira Mota 	2013-08-09	12	agosto	(27) 9 9907-3240	M	\N	Solteiro(a)	\N	Neudimar de oliveira mota	Evaristo canal 	52	Ipanema	Viana	ES	29134-513	t	t	Ativo	f	f	12-17	f	Sem Grupo	8	2025-11-04 09:11:50.787979	2026-05-11 16:39:04.365798	\N	f
LS20251104091151-PE3Y	74	Larissa	Theodoro da Silva	Larissa Theodoro da Silva 	1997-09-25	28	setembro	(27) 9 9689-3711	F	\N	Casado(a)	Richardson Silva Lopes 	\N	Itaguaçu 	35	Morada de Santa Fé	Cariacica	ES	29143-666	t	t	Ativo	f	t	18-29	f	Sem Grupo	9	2025-11-04 09:11:51.452279	2026-05-11 16:39:05.063076	\N	f
LH20251104091151-VG0U	76	Laura	rolim herpet	Laura rolim herpet	2018-10-13	7	outubro	(27) 9 9917-1122	F	\N	\N	\N	Mayra da silva rolim herpet 	Aparecida 	37	São Geraldo	Cariacica	ES	29146-653	f	f	Ativo	f	f	6-11	f	Sem Grupo	10	2025-11-04 09:11:51.565321	2026-05-11 16:39:05.170386	\N	f
LS20251104091151-VH2U	80	LETÍCIA	CALLOT PINTO DA SILVA	LETÍCIA CALLOT PINTO DA SILVA	1982-02-24	44	fevereiro	(27) 9 8853-6515	F	\N	Casado(a)	EDERSON FLÁVIO DA SILVA	\N	itabira 	59	São Geraldo 2	Cariacica	ES	29146-840	t	t	Ativo	f	f	30-44	f	Sem Grupo	2	2025-11-04 09:11:51.759819	2026-05-11 16:39:05.387978	/avatars/LS20251104091151-VH2U.jpg	f
LV20251104091151-OW5K	82	Lilian	de Souza Vieira	Lilian de Souza Vieira 	1991-05-28	34	maio	(27) 9 9850-4695	F	\N	Casado(a)	Willian de Oliveira souza 	\N	16	141	Nova Rosa Da Penha 1	Cariacica	ES	29157-414	t	f	Desligado	f	f	30-44	f	Sem Grupo	5	2025-11-04 09:11:51.853404	2026-05-11 16:39:05.510841	\N	f
MS20251104091152-LK0R	92	Maria	Alda Alves de Souza	Maria Alda Alves de Souza 	1980-04-04	46	abril	(27) 9 8803-5877	F	\N	Casado(a)	Leonardo Adame freire 	\N	jacaranda 	20 B	Parque Gramado	Cariacica	ES	29143-185	t	t	Ativo	f	f	45-59	f	Sem Grupo	4	2025-11-04 09:11:52.375661	2026-05-11 16:39:05.956254	/avatars/MS20251104091152-LK0R.jpg	f
MO20251104091152-WE7N	94	Maria	Eduarda monteiro Otávio	Maria Eduarda monteiro Otávio 	2009-04-28	17	abril	(27) 9 9836-1927	F	\N	Solteiro(a)	\N	Dayane monteiro costa	Abílio pontini 	145	São Geraldo 2	Cariacica	ES	29146-805	f	f	Ativo	f	f	12-17	f	Sem Grupo	4	2025-11-04 09:11:52.522707	2026-05-11 16:39:06.032524	\N	f
MN20251104091153-NG0I	108	Miria	Alves da Silva Nascimento	Miria Alves da Silva Nascimento 	1986-08-17	39	agosto	(27) 9 9531-0232	F	apt 302	Casado(a)	Rondiney Nascimento	\N	Ametista	25	São Geraldo 1	Cariacica	ES	29146-678	t	t	Ativo	f	f	30-44	f	Sem Grupo	8	2025-11-04 09:11:53.203785	2026-05-11 16:39:06.601805	/avatars/MN20251104091153-NG0I.jpg	f
MS20251104091152-JO2T	91	Maria	abadis dos santos	Maria abadis dos santos	1957-08-17	68	agosto	(27) 9 9691-8111	F	Viuva	Solteiro(a)	\N	\N	Orizonte feliz	02	Campina grande	Cariacica	ES	29144-306	t	t	Ativo	f	f	60+	f	Sem Grupo	8	2025-11-04 09:11:52.317096	2026-05-11 16:39:05.910386	\N	f
MB20251104091152-WQ4N	96	Maria	José Bergamini	Maria José Bergamini 	1961-04-13	65	abril	(27) 9 9959-2139	F		Casado(a)	Jean Carlos Bergamini 	\N	Itabira 	38	São Geraldo 2	Cariacica	ES	29146-840	t	t	Ativo	f	t	60+	f	Sem Grupo	4	2025-11-04 09:11:52.626471	2026-05-11 16:39:06.124814	/avatars/MB20251104091152-WQ4N.jpg	f
MA20251104091152-FB3E	97	Maricelia	da Cruz Izidoro Arantes Alves	Maricelia da Cruz Izidoro Arantes Alves 	1970-11-29	55	novembro	(27) 9 9258-8238	F	condomínio parque Vila Platina. Bloco 04 AP 506	Casado(a)	Odair Arantes Alves 	\N	Odonia da Costa Machado Toledo	311	Campina Grande	Cariacica	ES	29144-375	t	f	Desligado	f	f	45-59	f	Sem Grupo	11	2025-11-04 09:11:52.674391	2026-05-11 16:39:06.169444	\N	f
MH20251104091152-UC6S	100	Marvin	rolim herpet	Marvin rolim herpet 	2024-07-08	1	julho	(27) 9 9917-1122	M	\N	\N	\N	Mayra da silva rolim herpet 	Aparecida 	37	São Geraldo	Cariacica	ES	29146-653	f	f	Ativo	f	f	0-2	f	Sem Grupo	7	2025-11-04 09:11:52.813554	2026-05-11 16:39:06.308912	\N	f
MC20251104091152-EW4E	102	Matheus	Souza Cruz	Matheus Souza Cruz	1996-07-27	29	julho	(27) 9 8139-4281	M	\N	Casado(a)	Shauany Souza Gomes Cruz	\N	Dos Apostolos	20	Vila Palestina	Cariacica	ES	29145-630	t	f	Desligado	f	f	18-29	f	Sem Grupo	7	2025-11-04 09:11:52.905367	2026-05-11 16:39:06.387129	\N	f
MN20251104091153-CT8Z	107	Milena	Alves Nascimento	Milena Alves Nascimento	2019-04-17	7	abril	(27) 9 9531-0232	F	apt 302	Solteiro(a)	\N	Miria Alves da Silva Nascimento	Ametista	25	São Geraldo 1	Cariacica	ES	29146-679	f	f	Ativo	f	f	6-11	f	Sem Grupo	4	2025-11-04 09:11:53.155431	2026-05-11 16:39:06.558119	/avatars/MN20251104091153-CT8Z.jpg	f
NL20251104091153-OQ3X	110	Nathan	Ronquetti Lima	Nathan Ronquetti Lima	2023-03-07	3	março	(27) 9 9762-9765	M	\N	Solteiro(a)	\N	Gildazio Lima dos Santos	O	06	Campo verde	Viana	ES	29138-445	f	f	Ativo	f	f	3-5	f	Sem Grupo	3	2025-11-04 09:11:53.297248	2026-05-11 16:39:06.678671	/avatars/NL20251104091153-OQ3X.jpg	f
PC20251104091153-PV2G	116	Protazio	Rezende Carvalho	Protazio Rezende Carvalho 	1994-10-23	31	outubro	(27) 9 8816-2828	M	\N	Casado(a)	Thiffany Fernandes de Brito 	\N	Serra da mantiqueira 	66	Nova Bethânia	Viana	ES	29138-189	t	t	Ativo	f	f	30-44	f	Sem Grupo	10	2025-11-04 09:11:53.620859	2026-05-11 16:39:06.957469	\N	f
LS20251104091151-PK3C	84	Lorrainhe	da silva	Lorrainhe da silva	1988-06-26	37	junho	(27) 9 9654-7612	F	Divorciada	Solteiro(a)	\N	\N	Independência 	466	Cruzeiro do sul	Cariacica	ES	29144-060	t	t	Ativo	f	f	30-44	f	Sem Grupo	6	2025-11-04 09:11:51.964378	2026-05-11 16:39:05.618363	\N	f
MS20251104091152-LA7F	88	Maciel	de Araujo Sousa	Maciel de Araujo Sousa 	1990-02-22	36	fevereiro	(27)995033109	F	Mudar para batizado	Casado(a)	Aldeny Ferreira de Oliveira Sousa 	Esposa 	Porto seguro 	216	Tiradentes	Cariacica	ES	29143-508	t	t	Ativo	f	f	30-44	f	Sem Grupo	2	2025-11-04 09:11:52.177	2026-05-11 16:39:05.801168	/avatars/MS20251104091152-LA7F.jpg	f
MP20251104091152-LR7F	90	Mara	Lucia Tavares Pereira	Mara Lucia Tavares Pereira 	1964-12-23	61	dezembro	(27) 9 9745-9421	F		Casado(a)	Alívio de Souza Pereira 	\N	Monte Calvário 	03	Vila Palestina	Cariacica	ES	29145-760	t	t	Ativo	f	f	60+	f	Sem Grupo	12	2025-11-04 09:11:52.270622	2026-05-11 16:39:05.878139	/avatars/MP20251104091152-LR7F.jpg	f
SC20251104091154-VH5K	129	Shauany	Souza Gomes Cruz	Shauany Souza Gomes Cruz 	2002-05-29	23	maio	(27) 9 8900-3788	F	\N	Casado(a)	Matheus Souza Cruz 	\N	Rua dos apóstolos 	20	Vila Palestina	Cariacica	ES	\N	t	f	Desligado	f	f	18-29	f	Sem Grupo	5	2025-11-04 09:11:54.476398	2026-05-11 16:39:07.542602	\N	f
VA20251104091155-OF2K	140	Veruska	Pinto Mouzinho Almeida	Veruska Pinto Mouzinho Almeida	1994-09-18	31	setembro	(27) 9 9722-6172	F		Casado(a)	Ayrton Costa de Almeida 	\N	Otávio Cardoso de Alcântara 	40	Santa Fe	Cariacica	ES	29143-650	t	t	Ativo	f	t	30-44	f	Sem Grupo	9	2025-11-04 09:11:55.28755	2026-05-11 16:39:08.020078	\N	f
VS20251104091155-DL1Y	142	VITÓRIA	PINTO DA SILVA	VITÓRIA PINTO DA SILVA	2012-06-01	13	junho	(27) 9 9582-7788	F	\N	Solteiro(a)	\N	EDERSON FLÁVIO DA SILVA E LETÍCIA CALLOT DA SILVA	Itabira 	59	São Geraldo 2	Cariacica	ES	29146-840	t	t	Ativo	f	f	12-17	f	Sem Grupo	6	2025-11-04 09:11:55.395446	2026-05-11 16:39:08.094939	\N	f
WS20251104091155-XN3G	144	Willian	de Oliveira Souza	Willian de Oliveira Souza 	1988-03-07	38	março	(27) 9 9787-7484	M	\N	Casado(a)	Lilian de Souza Vieira 	\N	16	141	Nova Rosa da Penha 1	Cariacica	ES	29157-414	t	f	Desligado	f	f	30-44	f	Sem Grupo	3	2025-11-04 09:11:55.49933	2026-05-11 16:39:08.17199	\N	f
AR20251104091147-QQ6P	9	Ana	Gabrielly Rosa Rocha	Ana Gabrielly Rosa Rocha 	2013-09-20	12	setembro	(27) 9 9245-6124	F	\N	Solteiro(a)	\N	Bruna Lorrani Rocha Mousinho 	Ametista 	34	São Geraldo	Cariacica	ES	29146-677	f	f	Desligado	f	f	12-17	f	Sem Grupo	9	2025-11-04 09:11:47.856923	2026-05-11 16:39:02.264684	\N	f
NM20251104091153-TL6T	111	Neudimar	de oliveira mota	Neudimar de oliveira mota	1973-08-08	52	agosto	(27) 9 9907-3240	F	\N	Casado(a)	Ubiranel da Silveira Mota	\N	Evaristo canal 	52	Ipanema	Viana	ES	29134-513	t	t	Ativo	f	f	45-59	f	Sem Grupo	8	2025-11-04 09:11:53.346195	2026-05-11 16:39:06.725872	\N	f
NC20251104091153-IH4Y	112	Nilson	fraga Celestino	Nilson fraga Celestino 	1973-06-25	52	junho	(27) 9 9772-3358	M	\N	Casado(a)	Vasthi ferreira Gomes fraga 	\N	Atílio Esperandio 	249	Joana dark	Vitória	ES	29048-040	t	f	Desligado	f	f	45-59	f	Sem Grupo	6	2025-11-04 09:11:53.39271	2026-05-11 16:39:06.77053	\N	f
PF20251104091153-KW3F	115	Pedro	Torezani Ferreira	Pedro Torezani Ferreira 	2015-06-03	10	junho	(27) 9 9877-2135	M	\N	Solteiro(a)	\N	Fábio Nunes Ferreira 	Da comunidade 	255	Rosa da Penha	Cariacica	ES	29143-430	f	f	Ativo	f	f	6-11	f	Sem Grupo	6	2025-11-04 09:11:53.559852	2026-05-11 16:39:06.909944	\N	f
RF20251104091153-IC3G	122	Rina	Mendonça Gomes - Falecida	Rina Mendonça Gomes - Falecida	1976-12-23	49	dezembro	(27) 9 9859-0201	F	Óbito 05/10/2025	Casado(a)	Clebet de Jesus Sepulcro	\N	Claricio Alves Ribeiro	100	Itanguá	Cariacica	ES	29149-800 	t	f	Desligado	f	f	45-59	f	Sem Grupo	12	2025-11-04 09:11:53.938501	2026-05-11 16:39:07.208503	\N	f
RP20251104091153-ES4Y	123	Rita	de Cassia Rodrigues de paula	Rita de Cassia Rodrigues de paula 	1960-04-12	66	abril	(27) 9 9928-0162	F	Viuva	Viúvo(a)	\N	\N	coronel Bráulio dória 	93	São Cristóvão	Vitória	ES	\N	t	t	Ativo	f	f	60+	f	Sem Grupo	4	2025-11-04 09:11:53.998047	2026-05-11 16:39:07.264103	\N	f
SF20251104091154-QS9Y	128	Scheila	Aparecida Torezani Ferreira	Scheila Aparecida Torezani Ferreira 	1975-10-18	50	outubro	(27) 9 9877-2135	F		Casado(a)	Fábio Nunes Ferreira 	\N	Da comunidade 	255	Rosa da penha	Cariacica	ES	29143-430	t	t	Ativo	f	t	45-59	f	Sem Grupo	10	2025-11-04 09:11:54.39503	2026-05-11 16:39:07.496523	\N	f
AJ20251104091148-DK6V	13	Antonella	vitória Souza de jesus	Antonella vitória Souza de jesus 	2024-05-26	1	maio	(27) 9 9756-6031	F	\N	Solteiro(a)	\N	Bruna Luiza Souza Silva de Jesus 	São Benedito 	48	Cruzeiro do Sul	Cariacica	ES	29144-040	f	f	Desligado	f	f	0-2	f	Sem Grupo	5	2025-11-04 09:11:48.180274	2026-05-11 16:39:02.455784	\N	f
GA20251104091149-FR1V	46	Gabriel	Dondoni Alves	Gabriel Dondoni Alves 	1999-06-02	26	junho	(27) 9 9590-5817	M	\N	Casado(a)	Thamyres Coelho Dondoni 	\N	Guarapari 	19	Vista Dourada	Cariacica	ES	29158-652	t	f	Desligado	f	f	18-29	f	Sem Grupo	6	2025-11-04 09:11:49.903645	2026-05-11 16:39:03.806639	\N	f
\.


--
-- TOC entry 5511 (class 0 OID 17396)
-- Dependencies: 249
-- Data for Name: membros_funcoes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.membros_funcoes (id, membro_id, funcao_id, nivel_habilidade, preferencia, observacoes, created_at) FROM stdin;
\.


--
-- TOC entry 5513 (class 0 OID 17423)
-- Dependencies: 251
-- Data for Name: membros_grupos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.membros_grupos (id, membro_id, grupo_id, ativo, data_entrada, data_saida, observacoes, created_at) FROM stdin;
\.


--
-- TOC entry 5495 (class 0 OID 16831)
-- Dependencies: 233
-- Data for Name: membros_igreja; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.membros_igreja (id, nome_completo, nome_preferido, data_nascimento, sexo, estado_civil, telefone, email, endereco_completo, cep, cidade, estado, batizado, data_batismo, membro_oficial, data_membresia, status_atual, observacoes, usuario_sistema_id, created_at, updated_at) FROM stdin;
2	Maria Oliveira Costa	Maria	\N	\N	\N	(11) 88888-8888	maria@ibvp.com	\N	\N	\N	\N	t	\N	t	\N	Ativo	\N	\N	2025-11-04 16:15:00.117624	2025-11-04 16:15:00.117624
3	Pedro Henrique Souza	Pedro	\N	\N	\N	(11) 77777-7777	pedro@ibvp.com	\N	\N	\N	\N	t	\N	f	\N	Ativo	\N	\N	2025-11-04 16:15:00.117624	2025-11-04 16:15:00.117624
5	Maria Oliveira Costa	Maria	\N	\N	\N	(11) 88888-8888	maria@ibvp.com	\N	\N	\N	\N	t	\N	t	\N	Ativo	\N	\N	2025-11-04 16:19:12.146	2025-11-04 16:19:12.146
6	Pedro Henrique Souza	Pedro	\N	\N	\N	(11) 77777-7777	pedro@ibvp.com	\N	\N	\N	\N	t	\N	f	\N	Ativo	\N	\N	2025-11-04 16:19:12.146	2025-11-04 16:19:12.146
8	Maria Oliveira Costa	Maria	\N	\N	\N	(11) 88888-8888	maria@ibvp.com	\N	\N	\N	\N	t	\N	t	\N	Ativo	\N	\N	2025-11-04 16:20:18.312259	2025-11-04 16:20:18.312259
9	Pedro Henrique Souza	Pedro	\N	\N	\N	(11) 77777-7777	pedro@ibvp.com	\N	\N	\N	\N	t	\N	f	\N	Ativo	\N	\N	2025-11-04 16:20:18.312259	2025-11-04 16:20:18.312259
11	Maria Oliveira Costa	Maria	\N	\N	\N	(11) 88888-8888	maria@ibvp.com	\N	\N	\N	\N	t	\N	t	\N	Ativo	\N	\N	2025-11-04 16:21:10.579587	2025-11-04 16:21:10.579587
12	Pedro Henrique Souza	Pedro	\N	\N	\N	(11) 77777-7777	pedro@ibvp.com	\N	\N	\N	\N	t	\N	f	\N	Ativo	\N	\N	2025-11-04 16:21:10.579587	2025-11-04 16:21:10.579587
14	Maria Oliveira Costa	Maria	\N	\N	\N	(11) 88888-8888	maria@ibvp.com	\N	\N	\N	\N	t	\N	t	\N	Ativo	\N	\N	2025-11-04 16:42:55.104009	2025-11-04 16:42:55.104009
15	Pedro Henrique Souza	Pedro	\N	\N	\N	(11) 77777-7777	pedro@ibvp.com	\N	\N	\N	\N	t	\N	f	\N	Ativo	\N	\N	2025-11-04 16:42:55.104009	2025-11-04 16:42:55.104009
1	João Silva Santos	João	\N	\N	\N	(11) 99999-9999	joao@ibvp.com	\N	\N	\N	\N	t	\N	t	\N	Ativo	\N	4	2025-11-04 16:15:00.117624	2025-11-04 16:42:55.11742
4	João Silva Santos	João	\N	\N	\N	(11) 99999-9999	joao@ibvp.com	\N	\N	\N	\N	t	\N	t	\N	Ativo	\N	4	2025-11-04 16:19:12.146	2025-11-04 16:42:55.11742
7	João Silva Santos	João	\N	\N	\N	(11) 99999-9999	joao@ibvp.com	\N	\N	\N	\N	t	\N	t	\N	Ativo	\N	4	2025-11-04 16:20:18.312259	2025-11-04 16:42:55.11742
10	João Silva Santos	João	\N	\N	\N	(11) 99999-9999	joao@ibvp.com	\N	\N	\N	\N	t	\N	t	\N	Ativo	\N	4	2025-11-04 16:21:10.579587	2025-11-04 16:42:55.11742
13	João Silva Santos	João	\N	\N	\N	(11) 99999-9999	joao@ibvp.com	\N	\N	\N	\N	t	\N	t	\N	Ativo	\N	4	2025-11-04 16:42:55.104009	2025-11-04 16:42:55.11742
\.


--
-- TOC entry 5485 (class 0 OID 16660)
-- Dependencies: 223
-- Data for Name: musicas_acervo; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.musicas_acervo (id, titulo, artista, tonalidade_padrao, letra, cifra, link_youtube, link_spotify, tags, ativo, created_at, updated_at, observacoes, duracao_segundos) FROM stdin;
1	Ruja o Leão	Davi Sacer	G	\N	\N	\N	\N	["Adoração", "Animada"]	t	2025-11-05 15:31:06.1648	2025-11-05 15:31:06.1648	\N	\N
2	Oceanos	Hillsong	D	\N	\N	\N	\N	["Adoração", "Lenta"]	t	2025-11-05 15:31:06.1648	2025-11-05 15:31:06.1648	\N	\N
3	Teu Santo Nome	Gabriela Rocha	C	\N	\N	\N	\N	["Adoração", "Profunda"]	t	2025-11-05 15:31:06.1648	2025-11-05 15:31:06.1648	\N	\N
4	Nada Além do Sangue	Fernandinho	E	\N	\N	\N	\N	["Adoração", "Moderada"]	t	2025-11-05 15:31:06.1648	2025-11-05 15:31:06.1648	\N	\N
5	Porque Ele Vive	Coral Kemuel	G	\N	\N	\N	\N	["Adoração", "Clássica"]	t	2025-11-05 15:31:06.1648	2025-11-05 15:31:06.1648	\N	\N
6	Grande é o Senhor	Fernanda Brum	A	Grande é o Senhor e mui digno de louvor...	\N	https://youtube.com/exemplo	\N	["Adoração", "Moderada"]	t	2025-11-05 15:33:18.300078	2025-11-05 15:33:18.300078	\N	\N
7	Grande é o Senhor	Fernanda Brum	B	Grande é o Senhor e mui digno de louvor...	\N	https://youtube.com/exemplo	\N	["Adoração", "Poderosa", "Profunda"]	t	2025-11-05 15:33:49.856488	2025-11-05 15:33:49.920397	Tom alterado para B - Versão atualizada	\N
\.


--
-- TOC entry 5491 (class 0 OID 16785)
-- Dependencies: 229
-- Data for Name: niveis_acesso; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.niveis_acesso (id, codigo, nome, descricao, nivel_hierarquico, created_at) FROM stdin;
1	MESTRE	Usuário Mestre	Acesso total ao sistema, incluindo gerenciar outros usuários	1	2025-11-04 16:14:58.891621
2	ADMIN	Administrador	Acesso total ao sistema da igreja	2	2025-11-04 16:14:58.891621
3	ADMIN_MINISTERIO	Admin Ministério	Acesso completo apenas ao ministério específico	3	2025-11-04 16:14:58.891621
4	USUARIO	Usuário	Acesso limitado conforme vinculação aos ministérios	4	2025-11-04 16:14:58.891621
\.


--
-- TOC entry 5529 (class 0 OID 18009)
-- Dependencies: 271
-- Data for Name: usuarios; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.usuarios (id, username, senha_hash, tipo, membro_id, ativo, criado_em) FROM stdin;
1	IBVP	$2b$12$zgPrCt2cu4oof0XXutARL.3F3hUo1yYYiVMFztz4dEUqZ7VvYVSpG	MESTRE	\N	t	2025-11-06 15:05:55.452311
\.


--
-- TOC entry 5497 (class 0 OID 16903)
-- Dependencies: 235
-- Data for Name: usuarios_permissoes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.usuarios_permissoes (id, usuario_id, pode_gerenciar_usuarios, pode_gerenciar_membros, pode_ver_relatorios, pode_fazer_backup, ministerios_permitidos, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 5493 (class 0 OID 16801)
-- Dependencies: 231
-- Data for Name: usuarios_sistema; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.usuarios_sistema (id, nome_usuario, senha_hash, nivel_acesso_id, nome_completo, email, telefone, ativo, bloqueado, tentativas_login, bloqueado_ate, ultimo_login, ultimo_ip, criado_por, token_reset, token_expira, created_at, updated_at) FROM stdin;
40	veruska_pinto	$2b$10$g2sMseeBdVaPxHl5W/eg7ethF1EDH0XTLygiqFT4IXfyw1fWDdPwq	4	Veruska Pinto Mouzinho Almeida	\N	\N	t	f	0	\N	\N	\N	\N	\N	\N	2025-11-04 19:51:36.925526	2025-11-04 19:51:36.925526
41	vitor_pinto	$2b$10$g2sMseeBdVaPxHl5W/eg7ethF1EDH0XTLygiqFT4IXfyw1fWDdPwq	4	VITOR PINTO DA SILVA	\N	\N	t	f	0	\N	\N	\N	\N	\N	\N	2025-11-04 19:51:36.932496	2025-11-04 19:51:36.932496
42	vitoria_pinto	$2b$10$g2sMseeBdVaPxHl5W/eg7ethF1EDH0XTLygiqFT4IXfyw1fWDdPwq	4	VITÓRIA PINTO DA SILVA	\N	\N	t	f	0	\N	\N	\N	\N	\N	\N	2025-11-04 19:51:36.941335	2025-11-04 19:51:36.941335
43	erielton	$2b$10$DklqqvSGxnmOkSF6cae/g.zBxPObjXNbyCe/.O.gWevL/zIlVjXXe	1	Erielton De paula Melo 		\N	t	f	0	\N	\N	\N	\N	\N	\N	2025-11-05 09:24:55.44415	2025-11-06 09:13:38.082812
1	IBVP	$2b$12$Z49Xiez8tAP.8lMd1UyhFe/yIBD4d251mEManCK/uU3w7lIh7k7U.	1	Usuário Mestre IBVP	\N	\N	t	f	0	\N	\N	\N	\N	\N	\N	2025-11-04 16:14:58.891621	2025-11-04 16:42:54.400094
2	admin	$2b$12$lf.75Mk./xfw4BFCFdxZfOJTSFfecQfs7NgE8ZwmvqN/KBGrCLAS.	2	Administrador Geral	admin@ibvp.com	\N	t	f	0	\N	\N	\N	\N	\N	\N	2025-11-04 16:14:59.662091	2025-11-04 16:42:54.639547
3	admin_louvor	$2b$12$VjvUahjLa0mZyHTO/IMwv.1mtqv7anKgpaALRZG15vUhw6reiPj9K	3	Admin Ministério Louvor	louvor@ibvp.com	\N	t	f	0	\N	\N	\N	\N	\N	\N	2025-11-04 16:14:59.889436	2025-11-04 16:42:54.869802
4	joao_silva	$2b$12$gtl.fpaNXWjh6TvVg/g4ye6YaOGhoYYZGAXfh/62iiDRMGWEQvKGG	4	João Silva Santos	joao@ibvp.com	\N	t	f	0	\N	\N	\N	\N	\N	\N	2025-11-04 16:15:00.115089	2025-11-04 16:42:55.09597
22	MinistroTeste	$2b$10$5Xqf0YnVG5xD/ph6MUUl7eUQAmnAH1jvfRRvhtSrQCtxx3CvSZkia	3	\N	ministro@teste.com	\N	t	f	0	\N	\N	\N	\N	\N	\N	2025-11-04 17:56:11.837496	2025-11-04 17:56:11.837496
23	anny_nicolly	$2b$10$g2sMseeBdVaPxHl5W/eg7ethF1EDH0XTLygiqFT4IXfyw1fWDdPwq	4	Anny Nicolly de Souza Paixao 	\N	\N	t	f	0	\N	\N	\N	\N	\N	\N	2025-11-04 19:51:36.745239	2025-11-04 19:51:36.745239
24	ayrton_costa	$2b$10$g2sMseeBdVaPxHl5W/eg7ethF1EDH0XTLygiqFT4IXfyw1fWDdPwq	4	Ayrton Costa de Almeida	\N	\N	t	f	0	\N	\N	\N	\N	\N	\N	2025-11-04 19:51:36.79466	2025-11-04 19:51:36.79466
25	bruna_lorrani	$2b$10$g2sMseeBdVaPxHl5W/eg7ethF1EDH0XTLygiqFT4IXfyw1fWDdPwq	4	Bruna Lorrani Rocha Mousinho Viana 	\N	\N	t	f	0	\N	\N	\N	\N	\N	\N	2025-11-04 19:51:36.800575	2025-11-04 19:51:36.800575
26	christian_silva	$2b$10$g2sMseeBdVaPxHl5W/eg7ethF1EDH0XTLygiqFT4IXfyw1fWDdPwq	4	Christian da Silva Pereira	\N	\N	t	f	0	\N	\N	\N	\N	\N	\N	2025-11-04 19:51:36.813067	2025-11-04 19:51:36.813067
27	cleber_jesus	$2b$10$g2sMseeBdVaPxHl5W/eg7ethF1EDH0XTLygiqFT4IXfyw1fWDdPwq	4	Cleber de jesus Sepulcro 	\N	\N	t	f	0	\N	\N	\N	\N	\N	\N	2025-11-04 19:51:36.816865	2025-11-04 19:51:36.816865
28	crislayne_souza	$2b$10$g2sMseeBdVaPxHl5W/eg7ethF1EDH0XTLygiqFT4IXfyw1fWDdPwq	4	Crislayne de Souza Andrade Pereira 	\N	\N	t	f	0	\N	\N	\N	\N	\N	\N	2025-11-04 19:51:36.823971	2025-11-04 19:51:36.823971
29	flavio_siqueira	$2b$10$g2sMseeBdVaPxHl5W/eg7ethF1EDH0XTLygiqFT4IXfyw1fWDdPwq	4	Flávio Siqueira 	\N	\N	t	f	0	\N	\N	\N	\N	\N	\N	2025-11-04 19:51:36.83011	2025-11-04 19:51:36.83011
30	gabrielle_rocha	$2b$10$g2sMseeBdVaPxHl5W/eg7ethF1EDH0XTLygiqFT4IXfyw1fWDdPwq	4	Gabrielle Rocha Da Silva	\N	\N	t	f	0	\N	\N	\N	\N	\N	\N	2025-11-04 19:51:36.841125	2025-11-04 19:51:36.841125
31	grezieli_rocha	$2b$10$g2sMseeBdVaPxHl5W/eg7ethF1EDH0XTLygiqFT4IXfyw1fWDdPwq	4	Grezieli Rocha Mousinho 	\N	\N	t	f	0	\N	\N	\N	\N	\N	\N	2025-11-04 19:51:36.847414	2025-11-04 19:51:36.847414
32	jhonatan_souza	$2b$10$g2sMseeBdVaPxHl5W/eg7ethF1EDH0XTLygiqFT4IXfyw1fWDdPwq	4	Jhonatan de Souza Andrade	\N	\N	t	f	0	\N	\N	\N	\N	\N	\N	2025-11-04 19:51:36.85688	2025-11-04 19:51:36.85688
33	jilvanete_lima	$2b$10$g2sMseeBdVaPxHl5W/eg7ethF1EDH0XTLygiqFT4IXfyw1fWDdPwq	4	JILVANETE LIMA DOS SANTOS 	\N	\N	t	f	0	\N	\N	\N	\N	\N	\N	2025-11-04 19:51:36.864072	2025-11-04 19:51:36.864072
34	joscileia_ferreira	$2b$10$g2sMseeBdVaPxHl5W/eg7ethF1EDH0XTLygiqFT4IXfyw1fWDdPwq	4	Joscileia Ferreira de Oliveira 	\N	\N	t	f	0	\N	\N	\N	\N	\N	\N	2025-11-04 19:51:36.872881	2025-11-04 19:51:36.872881
35	lais_maria	$2b$10$g2sMseeBdVaPxHl5W/eg7ethF1EDH0XTLygiqFT4IXfyw1fWDdPwq	4	Lais Maria Pereira da Cruz 	\N	\N	t	f	0	\N	\N	\N	\N	\N	\N	2025-11-04 19:51:36.87962	2025-11-04 19:51:36.87962
36	larissa_theodoro	$2b$10$g2sMseeBdVaPxHl5W/eg7ethF1EDH0XTLygiqFT4IXfyw1fWDdPwq	4	Larissa Theodoro da Silva 	\N	\N	t	f	0	\N	\N	\N	\N	\N	\N	2025-11-04 19:51:36.888407	2025-11-04 19:51:36.888407
37	levindo_lucas	$2b$10$g2sMseeBdVaPxHl5W/eg7ethF1EDH0XTLygiqFT4IXfyw1fWDdPwq	4	Levindo Lucas da Cruz Neto	\N	\N	t	f	0	\N	\N	\N	\N	\N	\N	2025-11-04 19:51:36.896939	2025-11-04 19:51:36.896939
38	richardison_silva	$2b$10$g2sMseeBdVaPxHl5W/eg7ethF1EDH0XTLygiqFT4IXfyw1fWDdPwq	4	Richardison Silva Lopes 	\N	\N	t	f	0	\N	\N	\N	\N	\N	\N	2025-11-04 19:51:36.908081	2025-11-04 19:51:36.908081
39	scheila_aparecida	$2b$10$g2sMseeBdVaPxHl5W/eg7ethF1EDH0XTLygiqFT4IXfyw1fWDdPwq	4	Scheila Aparecida Torezani Ferreira 	\N	\N	t	f	0	\N	\N	\N	\N	\N	\N	2025-11-04 19:51:36.915323	2025-11-04 19:51:36.915323
\.


--
-- TOC entry 5610 (class 0 OID 0)
-- Dependencies: 258
-- Name: calendario_louvor_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.calendario_louvor_id_seq', 1, true);


--
-- TOC entry 5611 (class 0 OID 0)
-- Dependencies: 272
-- Name: church_settings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.church_settings_id_seq', 1, true);


--
-- TOC entry 5612 (class 0 OID 0)
-- Dependencies: 266
-- Name: cultos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cultos_id_seq', 30, true);


--
-- TOC entry 5613 (class 0 OID 0)
-- Dependencies: 256
-- Name: escala_musicas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.escala_musicas_id_seq', 9, true);


--
-- TOC entry 5614 (class 0 OID 0)
-- Dependencies: 254
-- Name: escala_participantes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.escala_participantes_id_seq', 3, true);


--
-- TOC entry 5615 (class 0 OID 0)
-- Dependencies: 252
-- Name: escalas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.escalas_id_seq', 7, true);


--
-- TOC entry 5616 (class 0 OID 0)
-- Dependencies: 246
-- Name: funcoes_louvor_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.funcoes_louvor_id_seq', 11, true);


--
-- TOC entry 5617 (class 0 OID 0)
-- Dependencies: 244
-- Name: grupos_louvor_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.grupos_louvor_id_seq', 3, true);


--
-- TOC entry 5618 (class 0 OID 0)
-- Dependencies: 262
-- Name: historico_escalas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.historico_escalas_id_seq', 8, true);


--
-- TOC entry 5619 (class 0 OID 0)
-- Dependencies: 260
-- Name: indisponibilidades_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.indisponibilidades_id_seq', 1, false);


--
-- TOC entry 5620 (class 0 OID 0)
-- Dependencies: 224
-- Name: instrumentos_equipamentos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.instrumentos_equipamentos_id_seq', 1, false);


--
-- TOC entry 5621 (class 0 OID 0)
-- Dependencies: 236
-- Name: instrumentos_inventario_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.instrumentos_inventario_id_seq', 7, true);


--
-- TOC entry 5622 (class 0 OID 0)
-- Dependencies: 238
-- Name: instrumentos_manutencoes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.instrumentos_manutencoes_id_seq', 1, false);


--
-- TOC entry 5623 (class 0 OID 0)
-- Dependencies: 240
-- Name: instrumentos_tipos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.instrumentos_tipos_id_seq', 15, true);


--
-- TOC entry 5624 (class 0 OID 0)
-- Dependencies: 242
-- Name: inventario_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.inventario_id_seq', 1, false);


--
-- TOC entry 5625 (class 0 OID 0)
-- Dependencies: 226
-- Name: manutencoes_instrumentos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.manutencoes_instrumentos_id_seq', 1, false);


--
-- TOC entry 5626 (class 0 OID 0)
-- Dependencies: 248
-- Name: membros_funcoes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.membros_funcoes_id_seq', 1, false);


--
-- TOC entry 5627 (class 0 OID 0)
-- Dependencies: 250
-- Name: membros_grupos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.membros_grupos_id_seq', 1, false);


--
-- TOC entry 5628 (class 0 OID 0)
-- Dependencies: 232
-- Name: membros_igreja_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.membros_igreja_id_seq', 15, true);


--
-- TOC entry 5629 (class 0 OID 0)
-- Dependencies: 222
-- Name: musicas_acervo_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.musicas_acervo_id_seq', 7, true);


--
-- TOC entry 5630 (class 0 OID 0)
-- Dependencies: 228
-- Name: niveis_acesso_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.niveis_acesso_id_seq', 24, true);


--
-- TOC entry 5631 (class 0 OID 0)
-- Dependencies: 270
-- Name: usuarios_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.usuarios_id_seq', 1, true);


--
-- TOC entry 5632 (class 0 OID 0)
-- Dependencies: 234
-- Name: usuarios_permissoes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.usuarios_permissoes_id_seq', 1, false);


--
-- TOC entry 5633 (class 0 OID 0)
-- Dependencies: 230
-- Name: usuarios_sistema_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.usuarios_sistema_id_seq', 43, true);


--
-- TOC entry 5257 (class 2606 OID 17571)
-- Name: calendario_louvor calendario_louvor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.calendario_louvor
    ADD CONSTRAINT calendario_louvor_pkey PRIMARY KEY (id);


--
-- TOC entry 5279 (class 2606 OID 18067)
-- Name: church_settings church_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.church_settings
    ADD CONSTRAINT church_settings_pkey PRIMARY KEY (id);


--
-- TOC entry 5269 (class 2606 OID 17699)
-- Name: cultos cultos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cultos
    ADD CONSTRAINT cultos_pkey PRIMARY KEY (id);


--
-- TOC entry 5253 (class 2606 OID 17546)
-- Name: escala_musicas escala_musicas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.escala_musicas
    ADD CONSTRAINT escala_musicas_pkey PRIMARY KEY (id);


--
-- TOC entry 5246 (class 2606 OID 17510)
-- Name: escala_participantes escala_participantes_escala_id_membro_id_funcao_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.escala_participantes
    ADD CONSTRAINT escala_participantes_escala_id_membro_id_funcao_id_key UNIQUE (escala_id, membro_id, funcao_id);


--
-- TOC entry 5248 (class 2606 OID 17508)
-- Name: escala_participantes escala_participantes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.escala_participantes
    ADD CONSTRAINT escala_participantes_pkey PRIMARY KEY (id);


--
-- TOC entry 5237 (class 2606 OID 17470)
-- Name: escalas escalas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.escalas
    ADD CONSTRAINT escalas_pkey PRIMARY KEY (id);


--
-- TOC entry 5239 (class 2606 OID 17472)
-- Name: escalas escalas_uuid_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.escalas
    ADD CONSTRAINT escalas_uuid_key UNIQUE (uuid);


--
-- TOC entry 5221 (class 2606 OID 17394)
-- Name: funcoes_louvor funcoes_louvor_nome_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.funcoes_louvor
    ADD CONSTRAINT funcoes_louvor_nome_key UNIQUE (nome);


--
-- TOC entry 5223 (class 2606 OID 17392)
-- Name: funcoes_louvor funcoes_louvor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.funcoes_louvor
    ADD CONSTRAINT funcoes_louvor_pkey PRIMARY KEY (id);


--
-- TOC entry 5217 (class 2606 OID 17369)
-- Name: grupos_louvor grupos_louvor_nome_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grupos_louvor
    ADD CONSTRAINT grupos_louvor_nome_key UNIQUE (nome);


--
-- TOC entry 5219 (class 2606 OID 17367)
-- Name: grupos_louvor grupos_louvor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grupos_louvor
    ADD CONSTRAINT grupos_louvor_pkey PRIMARY KEY (id);


--
-- TOC entry 5267 (class 2606 OID 17623)
-- Name: historico_escalas historico_escalas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.historico_escalas
    ADD CONSTRAINT historico_escalas_pkey PRIMARY KEY (id);


--
-- TOC entry 5265 (class 2606 OID 17605)
-- Name: indisponibilidades indisponibilidades_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.indisponibilidades
    ADD CONSTRAINT indisponibilidades_pkey PRIMARY KEY (id);


--
-- TOC entry 5174 (class 2606 OID 16735)
-- Name: instrumentos_equipamentos instrumentos_equipamentos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instrumentos_equipamentos
    ADD CONSTRAINT instrumentos_equipamentos_pkey PRIMARY KEY (id);


--
-- TOC entry 5199 (class 2606 OID 16976)
-- Name: instrumentos_inventario instrumentos_inventario_codigo_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instrumentos_inventario
    ADD CONSTRAINT instrumentos_inventario_codigo_key UNIQUE (codigo);


--
-- TOC entry 5201 (class 2606 OID 16974)
-- Name: instrumentos_inventario instrumentos_inventario_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instrumentos_inventario
    ADD CONSTRAINT instrumentos_inventario_pkey PRIMARY KEY (id);


--
-- TOC entry 5204 (class 2606 OID 17006)
-- Name: instrumentos_manutencoes instrumentos_manutencoes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instrumentos_manutencoes
    ADD CONSTRAINT instrumentos_manutencoes_pkey PRIMARY KEY (id);


--
-- TOC entry 5206 (class 2606 OID 17032)
-- Name: instrumentos_tipos instrumentos_tipos_nome_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instrumentos_tipos
    ADD CONSTRAINT instrumentos_tipos_nome_key UNIQUE (nome);


--
-- TOC entry 5208 (class 2606 OID 17030)
-- Name: instrumentos_tipos instrumentos_tipos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instrumentos_tipos
    ADD CONSTRAINT instrumentos_tipos_pkey PRIMARY KEY (id);


--
-- TOC entry 5215 (class 2606 OID 17174)
-- Name: inventario inventario_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventario
    ADD CONSTRAINT inventario_pkey PRIMARY KEY (id);


--
-- TOC entry 5176 (class 2606 OID 16754)
-- Name: manutencoes_instrumentos manutencoes_instrumentos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.manutencoes_instrumentos
    ADD CONSTRAINT manutencoes_instrumentos_pkey PRIMARY KEY (id);


--
-- TOC entry 5227 (class 2606 OID 17411)
-- Name: membros_funcoes membros_funcoes_membro_id_funcao_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.membros_funcoes
    ADD CONSTRAINT membros_funcoes_membro_id_funcao_id_key UNIQUE (membro_id, funcao_id);


--
-- TOC entry 5229 (class 2606 OID 17409)
-- Name: membros_funcoes membros_funcoes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.membros_funcoes
    ADD CONSTRAINT membros_funcoes_pkey PRIMARY KEY (id);


--
-- TOC entry 5233 (class 2606 OID 17438)
-- Name: membros_grupos membros_grupos_membro_id_grupo_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.membros_grupos
    ADD CONSTRAINT membros_grupos_membro_id_grupo_id_key UNIQUE (membro_id, grupo_id);


--
-- TOC entry 5235 (class 2606 OID 17436)
-- Name: membros_grupos membros_grupos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.membros_grupos
    ADD CONSTRAINT membros_grupos_pkey PRIMARY KEY (id);


--
-- TOC entry 5190 (class 2606 OID 16845)
-- Name: membros_igreja membros_igreja_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.membros_igreja
    ADD CONSTRAINT membros_igreja_pkey PRIMARY KEY (id);


--
-- TOC entry 5166 (class 2606 OID 16486)
-- Name: membros membros_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.membros
    ADD CONSTRAINT membros_pkey PRIMARY KEY (id);


--
-- TOC entry 5172 (class 2606 OID 16672)
-- Name: musicas_acervo musicas_acervo_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.musicas_acervo
    ADD CONSTRAINT musicas_acervo_pkey PRIMARY KEY (id);


--
-- TOC entry 5178 (class 2606 OID 16799)
-- Name: niveis_acesso niveis_acesso_codigo_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.niveis_acesso
    ADD CONSTRAINT niveis_acesso_codigo_key UNIQUE (codigo);


--
-- TOC entry 5180 (class 2606 OID 16797)
-- Name: niveis_acesso niveis_acesso_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.niveis_acesso
    ADD CONSTRAINT niveis_acesso_pkey PRIMARY KEY (id);


--
-- TOC entry 5192 (class 2606 OID 16918)
-- Name: usuarios_permissoes usuarios_permissoes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios_permissoes
    ADD CONSTRAINT usuarios_permissoes_pkey PRIMARY KEY (id);


--
-- TOC entry 5194 (class 2606 OID 16920)
-- Name: usuarios_permissoes usuarios_permissoes_usuario_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios_permissoes
    ADD CONSTRAINT usuarios_permissoes_usuario_id_key UNIQUE (usuario_id);


--
-- TOC entry 5275 (class 2606 OID 18022)
-- Name: usuarios usuarios_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_pkey PRIMARY KEY (id);


--
-- TOC entry 5184 (class 2606 OID 16819)
-- Name: usuarios_sistema usuarios_sistema_nome_usuario_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios_sistema
    ADD CONSTRAINT usuarios_sistema_nome_usuario_key UNIQUE (nome_usuario);


--
-- TOC entry 5186 (class 2606 OID 16817)
-- Name: usuarios_sistema usuarios_sistema_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios_sistema
    ADD CONSTRAINT usuarios_sistema_pkey PRIMARY KEY (id);


--
-- TOC entry 5277 (class 2606 OID 18024)
-- Name: usuarios usuarios_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_username_key UNIQUE (username);


--
-- TOC entry 5258 (class 1259 OID 17643)
-- Name: idx_calendario_data_inicio; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_calendario_data_inicio ON public.calendario_louvor USING btree (data_inicio);


--
-- TOC entry 5259 (class 1259 OID 17645)
-- Name: idx_calendario_escala; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_calendario_escala ON public.calendario_louvor USING btree (escala_id);


--
-- TOC entry 5260 (class 1259 OID 17646)
-- Name: idx_calendario_grupo; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_calendario_grupo ON public.calendario_louvor USING btree (grupo_id);


--
-- TOC entry 5261 (class 1259 OID 17644)
-- Name: idx_calendario_tipo; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_calendario_tipo ON public.calendario_louvor USING btree (tipo);


--
-- TOC entry 5270 (class 1259 OID 17708)
-- Name: idx_cultos_ativo; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_cultos_ativo ON public.cultos USING btree (ativo);


--
-- TOC entry 5271 (class 1259 OID 17705)
-- Name: idx_cultos_data; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_cultos_data ON public.cultos USING btree (data);


--
-- TOC entry 5272 (class 1259 OID 17706)
-- Name: idx_cultos_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_cultos_status ON public.cultos USING btree (status);


--
-- TOC entry 5273 (class 1259 OID 17707)
-- Name: idx_cultos_tipo; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_cultos_tipo ON public.cultos USING btree (tipo);


--
-- TOC entry 5254 (class 1259 OID 17641)
-- Name: idx_escala_musicas_escala; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_escala_musicas_escala ON public.escala_musicas USING btree (escala_id);


--
-- TOC entry 5255 (class 1259 OID 17642)
-- Name: idx_escala_musicas_ordem; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_escala_musicas_ordem ON public.escala_musicas USING btree (ordem);


--
-- TOC entry 5249 (class 1259 OID 17640)
-- Name: idx_escala_participantes_confirmado; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_escala_participantes_confirmado ON public.escala_participantes USING btree (confirmado);


--
-- TOC entry 5250 (class 1259 OID 17638)
-- Name: idx_escala_participantes_escala; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_escala_participantes_escala ON public.escala_participantes USING btree (escala_id);


--
-- TOC entry 5251 (class 1259 OID 17639)
-- Name: idx_escala_participantes_membro; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_escala_participantes_membro ON public.escala_participantes USING btree (membro_id);


--
-- TOC entry 5240 (class 1259 OID 17714)
-- Name: idx_escalas_culto; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_escalas_culto ON public.escalas USING btree (culto_id);


--
-- TOC entry 5241 (class 1259 OID 17634)
-- Name: idx_escalas_data; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_escalas_data ON public.escalas USING btree (data_evento);


--
-- TOC entry 5242 (class 1259 OID 17637)
-- Name: idx_escalas_data_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_escalas_data_status ON public.escalas USING btree (data_evento, status);


--
-- TOC entry 5243 (class 1259 OID 17636)
-- Name: idx_escalas_grupo; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_escalas_grupo ON public.escalas USING btree (grupo_id);


--
-- TOC entry 5244 (class 1259 OID 17635)
-- Name: idx_escalas_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_escalas_status ON public.escalas USING btree (status);


--
-- TOC entry 5262 (class 1259 OID 17648)
-- Name: idx_indisponibilidades_datas; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_indisponibilidades_datas ON public.indisponibilidades USING btree (data_inicio, data_fim);


--
-- TOC entry 5263 (class 1259 OID 17647)
-- Name: idx_indisponibilidades_membro; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_indisponibilidades_membro ON public.indisponibilidades USING btree (membro_id);


--
-- TOC entry 5195 (class 1259 OID 16987)
-- Name: idx_instrumentos_codigo; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_instrumentos_codigo ON public.instrumentos_inventario USING btree (codigo);


--
-- TOC entry 5196 (class 1259 OID 16989)
-- Name: idx_instrumentos_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_instrumentos_status ON public.instrumentos_inventario USING btree (status);


--
-- TOC entry 5197 (class 1259 OID 16988)
-- Name: idx_instrumentos_usuario; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_instrumentos_usuario ON public.instrumentos_inventario USING btree (usuario_id);


--
-- TOC entry 5209 (class 1259 OID 17177)
-- Name: idx_inventario_ativo; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_inventario_ativo ON public.inventario USING btree (ativo);


--
-- TOC entry 5210 (class 1259 OID 17175)
-- Name: idx_inventario_categoria; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_inventario_categoria ON public.inventario USING btree (categoria);


--
-- TOC entry 5211 (class 1259 OID 17178)
-- Name: idx_inventario_data_inventario; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_inventario_data_inventario ON public.inventario USING btree (data_inventario);


--
-- TOC entry 5212 (class 1259 OID 17176)
-- Name: idx_inventario_estado; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_inventario_estado ON public.inventario USING btree (estado);


--
-- TOC entry 5213 (class 1259 OID 17179)
-- Name: idx_inventario_nome_item; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_inventario_nome_item ON public.inventario USING btree (nome_item);


--
-- TOC entry 5202 (class 1259 OID 17017)
-- Name: idx_manutencoes_instrumento; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_manutencoes_instrumento ON public.instrumentos_manutencoes USING btree (instrumento_id);


--
-- TOC entry 5224 (class 1259 OID 17652)
-- Name: idx_membros_funcoes_funcao; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_membros_funcoes_funcao ON public.membros_funcoes USING btree (funcao_id);


--
-- TOC entry 5225 (class 1259 OID 17651)
-- Name: idx_membros_funcoes_membro; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_membros_funcoes_membro ON public.membros_funcoes USING btree (membro_id);


--
-- TOC entry 5230 (class 1259 OID 17650)
-- Name: idx_membros_grupos_grupo; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_membros_grupos_grupo ON public.membros_grupos USING btree (grupo_id);


--
-- TOC entry 5231 (class 1259 OID 17649)
-- Name: idx_membros_grupos_membro; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_membros_grupos_membro ON public.membros_grupos USING btree (membro_id);


--
-- TOC entry 5187 (class 1259 OID 16933)
-- Name: idx_membros_igreja_nome; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_membros_igreja_nome ON public.membros_igreja USING btree (nome_completo);


--
-- TOC entry 5188 (class 1259 OID 16934)
-- Name: idx_membros_igreja_usuario; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_membros_igreja_usuario ON public.membros_igreja USING btree (usuario_sistema_id);


--
-- TOC entry 5164 (class 1259 OID 17143)
-- Name: idx_membros_ministro; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_membros_ministro ON public.membros USING btree (ministro) WHERE (ministro = true);


--
-- TOC entry 5167 (class 1259 OID 17677)
-- Name: idx_musicas_artista; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_musicas_artista ON public.musicas_acervo USING btree (artista);


--
-- TOC entry 5168 (class 1259 OID 17678)
-- Name: idx_musicas_ativo; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_musicas_ativo ON public.musicas_acervo USING btree (ativo);


--
-- TOC entry 5169 (class 1259 OID 17679)
-- Name: idx_musicas_tags; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_musicas_tags ON public.musicas_acervo USING gin (to_tsvector('portuguese'::regconfig, tags));


--
-- TOC entry 5170 (class 1259 OID 16766)
-- Name: idx_musicas_titulo; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_musicas_titulo ON public.musicas_acervo USING btree (titulo);


--
-- TOC entry 5181 (class 1259 OID 16932)
-- Name: idx_usuarios_sistema_nivel; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_usuarios_sistema_nivel ON public.usuarios_sistema USING btree (nivel_acesso_id);


--
-- TOC entry 5182 (class 1259 OID 16931)
-- Name: idx_usuarios_sistema_nome; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_usuarios_sistema_nome ON public.usuarios_sistema USING btree (nome_usuario);


--
-- TOC entry 5479 (class 2618 OID 17666)
-- Name: vw_proximas_escalas _RETURN; Type: RULE; Schema: public; Owner: postgres
--

CREATE OR REPLACE VIEW public.vw_proximas_escalas AS
 SELECT e.id,
    e.titulo,
    e.data_evento,
    e.tipo_evento,
    e.status,
    e.local,
    g.nome AS grupo_nome,
    g.cor AS grupo_cor,
    m.nome_completo AS ministro_responsavel,
    count(DISTINCT ep.id) AS total_participantes,
    count(DISTINCT
        CASE
            WHEN (ep.confirmado = true) THEN ep.id
            ELSE NULL::integer
        END) AS participantes_confirmados,
    count(DISTINCT em.id) AS total_musicas
   FROM ((((public.escalas e
     LEFT JOIN public.grupos_louvor g ON ((e.grupo_id = g.id)))
     LEFT JOIN public.membros m ON ((e.ministro_responsavel_id = (m.id)::text)))
     LEFT JOIN public.escala_participantes ep ON ((e.id = ep.escala_id)))
     LEFT JOIN public.escala_musicas em ON ((e.id = em.escala_id)))
  WHERE ((e.data_evento >= CURRENT_DATE) AND ((e.status)::text <> 'CANCELADA'::text))
  GROUP BY e.id, g.nome, g.cor, m.nome_completo
  ORDER BY e.data_evento;


--
-- TOC entry 5314 (class 2620 OID 16507)
-- Name: membros membros_id_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER membros_id_trigger BEFORE INSERT ON public.membros FOR EACH ROW EXECUTE FUNCTION public.set_member_id();


--
-- TOC entry 5331 (class 2620 OID 17658)
-- Name: calendario_louvor trg_calendario_louvor_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_calendario_louvor_updated BEFORE UPDATE ON public.calendario_louvor FOR EACH ROW EXECUTE FUNCTION public.update_timestamp();


--
-- TOC entry 5326 (class 2620 OID 17660)
-- Name: escalas trg_criar_evento_calendario; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_criar_evento_calendario AFTER INSERT OR UPDATE ON public.escalas FOR EACH ROW EXECUTE FUNCTION public.criar_evento_calendario_escala();


--
-- TOC entry 5330 (class 2620 OID 17657)
-- Name: escala_musicas trg_escala_musicas_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_escala_musicas_updated BEFORE UPDATE ON public.escala_musicas FOR EACH ROW EXECUTE FUNCTION public.update_timestamp();


--
-- TOC entry 5329 (class 2620 OID 17656)
-- Name: escala_participantes trg_escala_participantes_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_escala_participantes_updated BEFORE UPDATE ON public.escala_participantes FOR EACH ROW EXECUTE FUNCTION public.update_timestamp();


--
-- TOC entry 5327 (class 2620 OID 17655)
-- Name: escalas trg_escalas_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_escalas_updated BEFORE UPDATE ON public.escalas FOR EACH ROW EXECUTE FUNCTION public.update_timestamp();


--
-- TOC entry 5325 (class 2620 OID 17654)
-- Name: grupos_louvor trg_grupos_louvor_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_grupos_louvor_updated BEFORE UPDATE ON public.grupos_louvor FOR EACH ROW EXECUTE FUNCTION public.update_timestamp();


--
-- TOC entry 5328 (class 2620 OID 17662)
-- Name: escalas trg_historico_escala; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_historico_escala AFTER INSERT OR UPDATE ON public.escalas FOR EACH ROW EXECUTE FUNCTION public.registrar_historico_escala();


--
-- TOC entry 5323 (class 2620 OID 17676)
-- Name: instrumentos_inventario trigger_auto_codigo_instrumento; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_auto_codigo_instrumento BEFORE INSERT ON public.instrumentos_inventario FOR EACH ROW EXECUTE FUNCTION public.auto_gerar_codigo_instrumento();


--
-- TOC entry 5634 (class 0 OID 0)
-- Dependencies: 5323
-- Name: TRIGGER trigger_auto_codigo_instrumento ON instrumentos_inventario; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TRIGGER trigger_auto_codigo_instrumento ON public.instrumentos_inventario IS 'Gera automaticamente o código do instrumento antes de inserir, caso não seja informado';


--
-- TOC entry 5315 (class 2620 OID 18049)
-- Name: membros trigger_numerodomes_insert; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_numerodomes_insert BEFORE INSERT ON public.membros FOR EACH ROW EXECUTE FUNCTION public.atualizar_numerodomes();


--
-- TOC entry 5316 (class 2620 OID 18050)
-- Name: membros trigger_numerodomes_update; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_numerodomes_update BEFORE UPDATE ON public.membros FOR EACH ROW WHEN ((new.data_nascimento IS DISTINCT FROM old.data_nascimento)) EXECUTE FUNCTION public.atualizar_numerodomes();


--
-- TOC entry 5324 (class 2620 OID 16991)
-- Name: instrumentos_inventario trigger_update_instrumentos_timestamp; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_update_instrumentos_timestamp BEFORE UPDATE ON public.instrumentos_inventario FOR EACH ROW EXECUTE FUNCTION public.update_instrumentos_updated_at();


--
-- TOC entry 5318 (class 2620 OID 17681)
-- Name: musicas_acervo trigger_update_musicas_timestamp; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_update_musicas_timestamp BEFORE UPDATE ON public.musicas_acervo FOR EACH ROW EXECUTE FUNCTION public.update_musicas_updated_at();


--
-- TOC entry 5320 (class 2620 OID 16783)
-- Name: instrumentos_equipamentos update_instrumentos_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_instrumentos_updated_at BEFORE UPDATE ON public.instrumentos_equipamentos FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 5322 (class 2620 OID 16954)
-- Name: membros_igreja update_membros_igreja_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_membros_igreja_updated_at BEFORE UPDATE ON public.membros_igreja FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 5317 (class 2620 OID 16479)
-- Name: membros update_membros_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_membros_updated_at BEFORE UPDATE ON public.membros FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 5319 (class 2620 OID 16781)
-- Name: musicas_acervo update_musicas_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_musicas_updated_at BEFORE UPDATE ON public.musicas_acervo FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 5321 (class 2620 OID 16953)
-- Name: usuarios_sistema update_usuarios_sistema_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_usuarios_sistema_updated_at BEFORE UPDATE ON public.usuarios_sistema FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 5306 (class 2606 OID 17582)
-- Name: calendario_louvor calendario_louvor_criado_por_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.calendario_louvor
    ADD CONSTRAINT calendario_louvor_criado_por_fkey FOREIGN KEY (criado_por) REFERENCES public.membros(id);


--
-- TOC entry 5307 (class 2606 OID 17572)
-- Name: calendario_louvor calendario_louvor_escala_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.calendario_louvor
    ADD CONSTRAINT calendario_louvor_escala_id_fkey FOREIGN KEY (escala_id) REFERENCES public.escalas(id) ON DELETE CASCADE;


--
-- TOC entry 5308 (class 2606 OID 17577)
-- Name: calendario_louvor calendario_louvor_grupo_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.calendario_louvor
    ADD CONSTRAINT calendario_louvor_grupo_id_fkey FOREIGN KEY (grupo_id) REFERENCES public.grupos_louvor(id) ON DELETE SET NULL;


--
-- TOC entry 5312 (class 2606 OID 17700)
-- Name: cultos cultos_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cultos
    ADD CONSTRAINT cultos_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.usuarios_sistema(id);


--
-- TOC entry 5305 (class 2606 OID 17547)
-- Name: escala_musicas escala_musicas_escala_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.escala_musicas
    ADD CONSTRAINT escala_musicas_escala_id_fkey FOREIGN KEY (escala_id) REFERENCES public.escalas(id) ON DELETE CASCADE;


--
-- TOC entry 5301 (class 2606 OID 17511)
-- Name: escala_participantes escala_participantes_escala_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.escala_participantes
    ADD CONSTRAINT escala_participantes_escala_id_fkey FOREIGN KEY (escala_id) REFERENCES public.escalas(id) ON DELETE CASCADE;


--
-- TOC entry 5302 (class 2606 OID 17521)
-- Name: escala_participantes escala_participantes_funcao_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.escala_participantes
    ADD CONSTRAINT escala_participantes_funcao_id_fkey FOREIGN KEY (funcao_id) REFERENCES public.funcoes_louvor(id) ON DELETE CASCADE;


--
-- TOC entry 5303 (class 2606 OID 17516)
-- Name: escala_participantes escala_participantes_membro_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.escala_participantes
    ADD CONSTRAINT escala_participantes_membro_id_fkey FOREIGN KEY (membro_id) REFERENCES public.membros(id) ON DELETE CASCADE;


--
-- TOC entry 5304 (class 2606 OID 17526)
-- Name: escala_participantes escala_participantes_substituto_de_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.escala_participantes
    ADD CONSTRAINT escala_participantes_substituto_de_fkey FOREIGN KEY (substituto_de) REFERENCES public.membros(id);


--
-- TOC entry 5296 (class 2606 OID 17488)
-- Name: escalas escalas_atualizado_por_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.escalas
    ADD CONSTRAINT escalas_atualizado_por_fkey FOREIGN KEY (atualizado_por) REFERENCES public.membros(id);


--
-- TOC entry 5297 (class 2606 OID 17483)
-- Name: escalas escalas_criado_por_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.escalas
    ADD CONSTRAINT escalas_criado_por_fkey FOREIGN KEY (criado_por) REFERENCES public.membros(id);


--
-- TOC entry 5298 (class 2606 OID 17709)
-- Name: escalas escalas_culto_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.escalas
    ADD CONSTRAINT escalas_culto_id_fkey FOREIGN KEY (culto_id) REFERENCES public.cultos(id) ON DELETE SET NULL;


--
-- TOC entry 5299 (class 2606 OID 17473)
-- Name: escalas escalas_grupo_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.escalas
    ADD CONSTRAINT escalas_grupo_id_fkey FOREIGN KEY (grupo_id) REFERENCES public.grupos_louvor(id) ON DELETE SET NULL;


--
-- TOC entry 5300 (class 2606 OID 17478)
-- Name: escalas escalas_ministro_responsavel_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.escalas
    ADD CONSTRAINT escalas_ministro_responsavel_id_fkey FOREIGN KEY (ministro_responsavel_id) REFERENCES public.membros(id);


--
-- TOC entry 5290 (class 2606 OID 17370)
-- Name: grupos_louvor grupos_louvor_lider_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grupos_louvor
    ADD CONSTRAINT grupos_louvor_lider_id_fkey FOREIGN KEY (lider_id) REFERENCES public.membros(id);


--
-- TOC entry 5291 (class 2606 OID 17375)
-- Name: grupos_louvor grupos_louvor_vice_lider_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grupos_louvor
    ADD CONSTRAINT grupos_louvor_vice_lider_id_fkey FOREIGN KEY (vice_lider_id) REFERENCES public.membros(id);


--
-- TOC entry 5310 (class 2606 OID 17624)
-- Name: historico_escalas historico_escalas_escala_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.historico_escalas
    ADD CONSTRAINT historico_escalas_escala_id_fkey FOREIGN KEY (escala_id) REFERENCES public.escalas(id) ON DELETE CASCADE;


--
-- TOC entry 5311 (class 2606 OID 17629)
-- Name: historico_escalas historico_escalas_realizado_por_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.historico_escalas
    ADD CONSTRAINT historico_escalas_realizado_por_fkey FOREIGN KEY (realizado_por) REFERENCES public.membros(id);


--
-- TOC entry 5309 (class 2606 OID 17606)
-- Name: indisponibilidades indisponibilidades_membro_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.indisponibilidades
    ADD CONSTRAINT indisponibilidades_membro_id_fkey FOREIGN KEY (membro_id) REFERENCES public.membros(id) ON DELETE CASCADE;


--
-- TOC entry 5280 (class 2606 OID 16736)
-- Name: instrumentos_equipamentos instrumentos_equipamentos_responsavel_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instrumentos_equipamentos
    ADD CONSTRAINT instrumentos_equipamentos_responsavel_id_fkey FOREIGN KEY (responsavel_id) REFERENCES public.membros(id);


--
-- TOC entry 5286 (class 2606 OID 16982)
-- Name: instrumentos_inventario instrumentos_inventario_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instrumentos_inventario
    ADD CONSTRAINT instrumentos_inventario_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.usuarios_sistema(id);


--
-- TOC entry 5287 (class 2606 OID 16977)
-- Name: instrumentos_inventario instrumentos_inventario_usuario_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instrumentos_inventario
    ADD CONSTRAINT instrumentos_inventario_usuario_id_fkey FOREIGN KEY (usuario_id) REFERENCES public.membros_igreja(id);


--
-- TOC entry 5288 (class 2606 OID 17012)
-- Name: instrumentos_manutencoes instrumentos_manutencoes_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instrumentos_manutencoes
    ADD CONSTRAINT instrumentos_manutencoes_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.usuarios_sistema(id);


--
-- TOC entry 5289 (class 2606 OID 17007)
-- Name: instrumentos_manutencoes instrumentos_manutencoes_instrumento_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instrumentos_manutencoes
    ADD CONSTRAINT instrumentos_manutencoes_instrumento_id_fkey FOREIGN KEY (instrumento_id) REFERENCES public.instrumentos_inventario(id) ON DELETE CASCADE;


--
-- TOC entry 5281 (class 2606 OID 16755)
-- Name: manutencoes_instrumentos manutencoes_instrumentos_instrumento_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.manutencoes_instrumentos
    ADD CONSTRAINT manutencoes_instrumentos_instrumento_id_fkey FOREIGN KEY (instrumento_id) REFERENCES public.instrumentos_equipamentos(id) ON DELETE CASCADE;


--
-- TOC entry 5292 (class 2606 OID 17417)
-- Name: membros_funcoes membros_funcoes_funcao_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.membros_funcoes
    ADD CONSTRAINT membros_funcoes_funcao_id_fkey FOREIGN KEY (funcao_id) REFERENCES public.funcoes_louvor(id) ON DELETE CASCADE;


--
-- TOC entry 5293 (class 2606 OID 17412)
-- Name: membros_funcoes membros_funcoes_membro_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.membros_funcoes
    ADD CONSTRAINT membros_funcoes_membro_id_fkey FOREIGN KEY (membro_id) REFERENCES public.membros(id) ON DELETE CASCADE;


--
-- TOC entry 5294 (class 2606 OID 17444)
-- Name: membros_grupos membros_grupos_grupo_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.membros_grupos
    ADD CONSTRAINT membros_grupos_grupo_id_fkey FOREIGN KEY (grupo_id) REFERENCES public.grupos_louvor(id) ON DELETE CASCADE;


--
-- TOC entry 5295 (class 2606 OID 17439)
-- Name: membros_grupos membros_grupos_membro_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.membros_grupos
    ADD CONSTRAINT membros_grupos_membro_id_fkey FOREIGN KEY (membro_id) REFERENCES public.membros(id) ON DELETE CASCADE;


--
-- TOC entry 5284 (class 2606 OID 16846)
-- Name: membros_igreja membros_igreja_usuario_sistema_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.membros_igreja
    ADD CONSTRAINT membros_igreja_usuario_sistema_id_fkey FOREIGN KEY (usuario_sistema_id) REFERENCES public.usuarios_sistema(id);


--
-- TOC entry 5313 (class 2606 OID 18025)
-- Name: usuarios usuarios_membro_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_membro_id_fkey FOREIGN KEY (membro_id) REFERENCES public.membros(id);


--
-- TOC entry 5285 (class 2606 OID 16921)
-- Name: usuarios_permissoes usuarios_permissoes_usuario_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios_permissoes
    ADD CONSTRAINT usuarios_permissoes_usuario_id_fkey FOREIGN KEY (usuario_id) REFERENCES public.usuarios_sistema(id) ON DELETE CASCADE;


--
-- TOC entry 5282 (class 2606 OID 16825)
-- Name: usuarios_sistema usuarios_sistema_criado_por_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios_sistema
    ADD CONSTRAINT usuarios_sistema_criado_por_fkey FOREIGN KEY (criado_por) REFERENCES public.usuarios_sistema(id);


--
-- TOC entry 5283 (class 2606 OID 16820)
-- Name: usuarios_sistema usuarios_sistema_nivel_acesso_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios_sistema
    ADD CONSTRAINT usuarios_sistema_nivel_acesso_id_fkey FOREIGN KEY (nivel_acesso_id) REFERENCES public.niveis_acesso(id);


--
-- TOC entry 5538 (class 0 OID 0)
-- Dependencies: 5537
-- Name: DATABASE dashboard_membros; Type: ACL; Schema: -; Owner: postgres
--

GRANT ALL ON DATABASE dashboard_membros TO membros_user;


-- Completed on 2026-05-19 13:26:47

--
-- PostgreSQL database dump complete
--

\unrestrict tu0EofNZdPLsjbcUfxbNuc1n5z9wvCZDi3C97BZnrgLeKkkpCOeRX1Djff6PuTu

--
-- Database "postgres" dump
--

\connect postgres

--
-- PostgreSQL database dump
--

\restrict kChJPUno9orGEIY4Mdhd6MDwnahYqIXvqRbzBXDGPCxFuLygco4cxwIwM065fei

-- Dumped from database version 18.0
-- Dumped by pg_dump version 18.0

-- Started on 2026-05-19 13:26:47

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

-- Completed on 2026-05-19 13:26:47

--
-- PostgreSQL database dump complete
--

\unrestrict kChJPUno9orGEIY4Mdhd6MDwnahYqIXvqRbzBXDGPCxFuLygco4cxwIwM065fei

-- Completed on 2026-05-19 13:26:47

--
-- PostgreSQL database cluster dump complete
--

