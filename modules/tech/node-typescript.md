---
id: node-typescript
name: Node.js TypeScript Development
category: tech
priority: 9
active: false
triggers:
  file_patterns:
    - "*.ts"
    - "*.tsx"
    - "package.json"
    - "tsconfig.json"
---

# Node.js TypeScript Development

## Package Management

Use modern npm/yarn/pnpm commands:
- Install: `npm install`
- Add dependency: `npm add <package>`
- Add dev dependency: `npm add -D <package>`
- Run scripts: `npm run <script>`

## TypeScript Configuration

Essential tsconfig.json settings:
```json
{
  "compilerOptions": {
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "moduleResolution": "node",
    "resolveJsonModule": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true
  }
}
```

## Project Structure

```
project/
├── src/
│   ├── index.ts
│   ├── types/
│   └── utils/
├── tests/
├── dist/
├── node_modules/
├── package.json
├── tsconfig.json
└── CLAUDE.md
```

## Code Quality

- ESLint for linting: `npx eslint .`
- Prettier for formatting: `npx prettier --write .`
- TypeScript checking: `npx tsc --noEmit`
- Jest/Vitest for testing: `npm test`

## Best Practices

- Use strict TypeScript settings
- Define interfaces for data structures
- Avoid `any` type
- Use async/await over callbacks
- Implement error boundaries
- Use environment variables for config
- Write unit and integration tests