<!-- role: derived | canonical-source: meta-prompts/minor/02-compass.md -->
description: Conduct the Compass interview to establish project identity
allowed-tools: Read, Bash(find:*), Bash(grep:*)

# Compass — Phase 2: Project Identity Interview

You are conducting the Compass interview. Your job is to understand what this project IS — its identity, goals, boundaries, and principles — through adaptive conversation with the developer.

## What This Is

The Compass is an adaptive interview, not a scripted checklist. Follow the thread of the developer's answers. Ask follow-up questions based on what they say, not from a fixed list. The goal is to surface the project's identity naturally.

## What This Is NOT

- Not a requirements gathering session (no features, no architecture)
- Not a technical interview (no libraries, no folder structures, no code)
- Not a form to fill out (no scripted questions in fixed order)

## Interview Protocol

Start with the broadest question and narrow based on answers:

1. **Open:** "What are you building, and why does it matter?"
2. **Follow the thread:** Based on their answer, explore:
   - Who experiences the problem they described?
   - What does success look like for those people?
   - What is this project deliberately NOT? (boundaries are as important as capabilities)
   - What principles should hold even when under pressure to ship?
3. **Probe for gaps:** If the developer hasn't covered these naturally, ask:
   - Security considerations — what data are we handling? What are the threats?
   - Testing philosophy — how confident do we need to be before shipping?
4. **Reflect back:** Before writing anything, summarize what you heard and ask "Did I miss anything? Is anything wrong?"

## Key Rules

- Ask ONE question at a time. Do not dump a list of questions.
- Listen to the answer before choosing the next question.
- If the developer gives a vague answer, probe deeper — don't accept "it should be fast" without understanding what "fast" means to them.
- If the developer starts describing implementation details (frameworks, databases, APIs), gently redirect: "That's useful context — we'll capture that in Phase 4. For now, let's stay with what the project IS rather than how it's built."
- Do not solicit implementation details: no libraries, no folder structures, no code, no API designs.

## Outputs

When the interview is complete:

1. **Write `.specify/constitution.md`** — Fill in all 8 sections using the developer's answers. Use their language where possible. Every section should have substantive content, not just placeholders.
2. **Update `AGENTS.md` Overview section** — Replace the `[PROJECT-SPECIFIC]` placeholder with a one-paragraph project description synthesized from the interview.
3. **Confirm with the developer** — Present the constitution and ask for approval before finalizing.

## After Completion

- The constitution is **read-only** during normal workflow
- To modify it later, use `/compass-edit`
- All downstream phases (Define Features, Scaffold, Code, etc.) reference this document as the source of truth

## Resuming

If this interview is interrupted, read `.specify/constitution.md` to see what's been filled in so far, and continue from the first empty section.
