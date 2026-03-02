# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

```bash
npm run dev        # Start dev server on port 8080
npm run build      # Production build
npm run build:dev  # Development mode build
npm run lint       # ESLint validation
npm run preview    # Preview production build
```

No test runner is configured in this project.

## Architecture Overview

WhiteSands CRM is a React 18 + TypeScript SPA built with Vite. The backend is entirely Supabase (PostgreSQL + Auth). There is no separate server — API calls go directly to Supabase from the browser.

**Core stack:** React 18, TypeScript, Vite/SWC, Tailwind CSS, shadcn-ui (Radix UI), TanStack Query v5, React Router v6, Supabase.

### Key Directories

- `src/pages/` — Route-level page components (28+). Each major feature has its own page.
- `src/components/` — Feature-organized components (admin/, auth/, calls/, contacts/, companies/, deals/, eod/, dar/, reports/, tasks/, layout/, ui/).
- `src/components/ui/` — shadcn-ui primitives. Do not modify these directly.
- `src/integrations/supabase/` — Supabase client (`client.ts`), auth utilities (`auth.ts`), and auto-generated DB types (`types.ts`). The types file is generated — don't manually edit it.
- `src/utils/` — Business logic utilities: `pointsEngine.ts`, `streakCalculation.ts`, `behaviorAnalysis.ts`, `eodCalculations.ts`, `hoursCalculation.ts`, `snapshotService.ts`, `timezoneUtils.ts`.
- `src/hooks/` — Custom React hooks including Dialpad CTI sync hooks.
- `src/contexts/SurveyContext.tsx` — Global mood/energy survey system context.
- `src/lib/queryClient.ts` — TanStack Query config (5-min stale time, 30-min cache, refetch on reconnect).

### Routing & Auth

- React Router v6 with all routes defined in `src/App.tsx`.
- All page components are lazy-loaded via `React.lazy()`.
- `src/components/auth/ProtectedRoute.tsx` handles auth guarding. Admin-only routes use a separate role check.

### State Management

- Server state: TanStack Query (React Query v5) — all Supabase fetches go through `useQuery`/`useMutation`.
- Client state: local `useState`. Global survey state via `SurveyContext`.
- No Redux or Zustand.

### Supabase Integration

- Client initialized in `src/integrations/supabase/client.ts` using `VITE_SUPABASE_URL` and `VITE_SUPABASE_ANON_KEY`.
- Real-time subscriptions are used in several components.
- Auto-generated TypeScript types live in `src/integrations/supabase/types.ts` — regenerate with the Supabase CLI when schema changes.
- Some admin operations use the service role key (set via environment variable, not committed).

### Styling Conventions

- Tailwind CSS with class-based dark mode.
- Custom color palette: `gold-*` and `dark-*` tokens defined in `tailwind.config.ts`.
- Custom fonts: Cinzel (headings) and Montserrat (body).
- shadcn-ui components are the base UI layer — extend rather than replace.

### Path Aliases

`@/*` resolves to `src/*` (configured in both `tsconfig.json` and `vite.config.ts`).

### Notable Large Files

- `src/pages/EODPortal.tsx` (~300KB) — End-of-day reporting with surveys, mood tracking, metrics.
- `src/pages/SmartDARDashboard.tsx` (~128KB) — Daily Activity Report analytics.
- `src/pages/Admin.tsx` (~105KB) — System administration panel.

These files are intentionally large feature modules. Prefer editing in-place and extracting sub-components into `src/components/eod/`, `src/components/dar/`, or `src/components/admin/` when adding significant new functionality.

### Integrations

- **Dialpad CTI:** VoIP phone integration via `useDialpadSync` / `useDialpadAutoSync` hooks and a `CTIProvider`.
- **Resend:** Email sending.
- **ExcelJS / XLSX:** Excel export functionality.
- **Recharts:** Analytics charts.
- **@dnd-kit:** Drag-and-drop in pipeline/task views.
- **Sonner:** Toast notifications (use `toast()` from `sonner`, not the shadcn toast).

### Environment Variables

```
VITE_SUPABASE_URL=
VITE_SUPABASE_ANON_KEY=
```
