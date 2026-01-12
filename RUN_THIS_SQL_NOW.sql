-- ⚡ RUN THIS SQL IN SUPABASE SQL EDITOR NOW
-- This adds all missing company fields to your database

-- Add missing fields to companies table
ALTER TABLE public.companies ADD COLUMN IF NOT EXISTS owner_id UUID;
ALTER TABLE public.companies ADD COLUMN IF NOT EXISTS vertical TEXT;
ALTER TABLE public.companies ADD COLUMN IF NOT EXISTS email TEXT;
ALTER TABLE public.companies ADD COLUMN IF NOT EXISTS timezone TEXT DEFAULT 'America/New_York';
ALTER TABLE public.companies ADD COLUMN IF NOT EXISTS zip_code TEXT;

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_companies_owner_id ON public.companies(owner_id);
CREATE INDEX IF NOT EXISTS idx_companies_vertical ON public.companies(vertical);
CREATE INDEX IF NOT EXISTS idx_companies_email ON public.companies(email);
CREATE INDEX IF NOT EXISTS idx_companies_zip_code ON public.companies(zip_code);

-- Add comments for documentation
COMMENT ON COLUMN public.companies.owner_id IS 'User who owns/manages this company';
COMMENT ON COLUMN public.companies.vertical IS 'Business vertical or industry category';
COMMENT ON COLUMN public.companies.email IS 'Company primary email address';
COMMENT ON COLUMN public.companies.timezone IS 'Company timezone';
COMMENT ON COLUMN public.companies.zip_code IS 'Company ZIP/postal code';

-- Verify columns were added
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_name = 'companies'
AND column_name IN ('owner_id', 'vertical', 'email', 'timezone', 'zip_code')
ORDER BY column_name;
