# Aula 02 — 07/08/2026

## Retomada da Revisão de SQL

Quando uma **seta em negrito** é utilizada em um diagrama, ela representa uma **entidade fraca**. Isso significa que a entidade possui uma **chave primária composta**, formada pela chave estrangeira (FK) da entidade principal.

### Exemplo

**Funcionário (1,1) ──► Dependente (0,N)**

Nesse caso, **Dependente** é uma entidade fraca, pois sua existência depende da entidade **Funcionário**. Portanto, ao desativar um funcionário, todos os seus dependentes também serão desativados.

> **Observações**
>
> * A **seta contínua em negrito** representa uma **entidade fraca**.
> * **Autorrelacionamento**: ocorre quando uma entidade se relaciona consigo mesma. Exemplo: identificar **quem é chefe de quem** dentro da entidade **Funcionário**.
