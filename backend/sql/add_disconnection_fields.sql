ALTER TABLE membros
  ADD COLUMN IF NOT EXISTS motivo_desligamento TEXT;

ALTER TABLE membros
  ADD COLUMN IF NOT EXISTS data_desligamento DATE;

ALTER TABLE membros
  ADD COLUMN IF NOT EXISTS data_batismo DATE;