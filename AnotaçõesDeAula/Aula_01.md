# Aula 01 - Dia 31.07.2026

As avaliações podem levar uma **folha A4** escrita à mão, e as avaliações têm alto nível de dificuldade.

# Regras Gerais

* Sem espaços ou caracteres especiais: não utilizar espaços, acentos ou hifens. Para separar as palavras, utilizar `PascalCase` ou `snake_case`.
* Evitar palavras-chave: nunca nomear um objeto com uma palavra reservada do SQL, como `SELECT` ou `TABLE`.
* Em tabelas: recomenda-se usar `PascalCase` no `Singular`.

# Revisão dos conceitos/prática do SQL

* Modelo Entidade-Relacionamento Conceitual:
  * Usa-se retângulo: pode representar algo do mundo real ou abstrato.
  * Relação: a palavra `relação` tem o significado de tabela.
  * Toda entidade necessita de uma `chave primária`.
  * Atributo composto: quando possui outros atributos. Exemplo: endereço contém (rua, número, CEP, complemento) e está ligado a `Funcionário`.
  * No atributo pode ser (1, N), o que significa que pode conter um para muitos.
  * Para fazer a cardinalidade, sempre tem que pegar o máximo e o mínimo (minimax).
  * Quando tem um caso de (1,1) gerencia (0,1) a chave-estrangeira ficará no `Departamento`.
  * Sempre que tiver um caso (1,1) sempre se perguntar `Faz sentido ter essa entidade?`. 

Lembrando:
> Sempre que tiver  (N,N) obrigatoriamente criar um **nova tabela**, que se chama `ENTIDADE ASSOCIATIVA`. Não precisa colocar a chave primária, mas será uma **chave composta**. No modelo conceitual para representar pode ser
1  N | | N - 1
 
> O principal motivo do uso de banco de dados em vez do Excel é a integração e a ausência de **duplicidade**, pois cada dado deve conter um índice que o identifique. No modelo conceitual, não é necessário colocar a chave estrangeira.

> O N sempre puxa a chave primária.

# Uso da ferramenta **brModelo**
Construção do modelo conceitual, lógico.
<img width="1031" height="831" alt="Conceitual_1" src="https://github.com/user-attachments/assets/4ea704cf-2454-477e-a4d1-ce27a92d3009"/>


