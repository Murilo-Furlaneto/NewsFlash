# NewsFlash App


> Aplicativo móvel para exibir notícias atualizadas em tempo real, consumindo uma API pública de notícias. Navegue por categorias, leia artigos completos, salve favoritos para leitura offline e compartilhe notícias facilmente.

---

## 🚧 Status do Projeto

:construction: Projeto em desenvolvimento :construction:

---

## 📋 Sumário

- [Descrição](#descrição)
- [Público-Alvo](#público-alvo)
- [Tecnologias Utilizadas](#tecnologias-utilizadas)
- [Funcionalidades](#funcionalidades)

---

## Descrição

O **NewsFlash App** é um aplicativo Flutter que oferece acesso rápido e intuitivo a notícias atualizadas em tempo real, consumindo a API pública NewsAPI.org. O app permite navegar por categorias, buscar notícias por palavras-chave, salvar artigos favoritos para leitura offline e compartilhar conteúdos em redes sociais.

---

## Público-Alvo

- Usuários que desejam acompanhar notícias atuais de forma prática pelo celular.
- Interessados em diversas categorias como tecnologia, esportes, política, entretenimento, entre outras.
- Pessoas que querem salvar artigos para leitura posterior, mesmo sem conexão.

---

## Tecnologias Utilizadas

- **Frontend:** Flutter (Dart)
- **Gerenciamento de Estado:** Cubit
- **Persistência Local:** Hive
- **API de Notícias:** NewsAPI.org
- **Outros:** share_plus (compartilhamento), notificações locais (futuro)

---

## Funcionalidades

- Tela inicial com lista de notícias recentes e em destaque, com rolagem infinita.
- Busca de notícias por palavra-chave com debounce para otimização.
- Navegação por categorias (Tecnologia, Esportes, Saúde, Negócios, Entretenimento).
- Visualização detalhada da notícia com título, imagem, autor, conteúdo completo e ações.
- Salvar e remover notícias favoritas com acesso offline.
- Compartilhamento fácil via sistema para redes sociais e apps de mensagem.
- Abertura da notícia original no navegador.
- Configurações para limpeza de cache e tema (versão futura).

