-- Script para liberar acesso anônimo às tabelas no Supabase (Desativar RLS para Admin Local simulado)
-- Rode isso no SQL Editor do seu painel Supabase (https://supabase.com/dashboard/project/_/sql)

-- 1. Habilitamos RLS (caso não esteja) 
ALTER TABLE public.products ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.promotions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.config ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.orders ENABLE ROW LEVEL SECURITY;

-- 2. Apagamos políticas antigas (se houverem) para evitar conflitos
DROP POLICY IF EXISTS "Liberar tudo" ON public.products;
DROP POLICY IF EXISTS "Liberar tudo" ON public.categories;
DROP POLICY IF EXISTS "Liberar tudo" ON public.promotions;
DROP POLICY IF EXISTS "Liberar tudo" ON public.config;
DROP POLICY IF EXISTS "Liberar tudo" ON public.orders;

-- 3. Criamos uma política permissiva para TUDO (Select, Insert, Update, Delete)
-- ATENÇÃO: Em produção real com usuários, usaríamos permissões baseadas no usuário autenticado auth.uid()
-- Como sua autenticação de admin (admin/admin123) não está no auth do Supabase, precisamos liberar para o anon no momento:

CREATE POLICY "Permitir leitura/escrita anonima" ON public.products FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Permitir leitura/escrita anonima" ON public.categories FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Permitir leitura/escrita anonima" ON public.promotions FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Permitir leitura/escrita anonima" ON public.config FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Permitir leitura/escrita anonima" ON public.orders FOR ALL USING (true) WITH CHECK (true);

-- Libera também as imagens no Storage (Bucket 'images')
CREATE POLICY "Public Access" 
  ON storage.objects FOR ALL 
  USING (bucket_id = 'images') 
  WITH CHECK (bucket_id = 'images');
