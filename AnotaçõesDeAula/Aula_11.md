## Aula 11 - Dia 09.10.2026

### Transações
A transações podem incluir **inserções,atualizações,exclusões ou consultar**. Essa operação deve ser completamente **concluída ou completamente revertida** para garantia que o bd permaneça em um estado consistente.
O principal objetivo é garantir a integridade e consistência de dados, mesmo diante de falhas.
Exemplo: se tiver cinco INSERT todos devem ser corretamente funcionando para funcionamento da transação.Todo SBGD tem que obdecer o `ACID`:

- `A`tomicidade: não divivel
- `C`onsistência: estado válido - válido
- `I`solamento: 1 por vez
- `D`urabilidade: fazer os dados persistir/persistência

**Comando utilizado: TRANSACTION**  é utilizado para uma sequência de operações (transações) no banco.

**Para que serve uma transação?**
- Garantir integridade e consistência dos dados:
- Reverter alterações em caso de erro:
- Controlar múltiplas operações simultâneas

---

### Atomicidade
Garante que uma transação é tratada como uma única unidade, ou seja, não é divivel, que significa que ela deve ser completamente concluída ou totalmente desfeita.

---

### Consistência
Garante que o banco de dados de um **estado válido para outro estado válido**, respeitando todas as regras definidas.

---

### Isolamento
Transações sejam executadas de forma isolada, sem que as operações de uma transação afetem as operações de outra.**Trata um requisição por vez.**

---

### Durabilidade
Deve garantir que uma vez que uma transação é **confirmada(committed)**, ela fique no bando de dados mesmo que ocorra uma falha no sistema.

---

### Comandos
```sql
-- INICIA UMA NOVA TRANSAÇÃO
BEGIN TRANSACTION

-- CONFIRMA A TRANSAÇÃO APLICANDO PERMANENTEMENTE TODAS AS OPERACOES FEITOS NO BD
COMMIT TRANSACTION

-- DESFAZ TODAS AS OPERACOES REALIZADAS DESDE O INICIO DA TRANSAÇÃO
ROLLBACK TRANSACTION

--- DEFINE UM PONTO DENTRO DE UMA TRANSAÇÃO PARA PERMITER UM ROLLBACK PARCIAL 
SAVEPOINT 
```


