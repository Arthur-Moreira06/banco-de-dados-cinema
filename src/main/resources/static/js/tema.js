(() => {
  const chave = "cinema-tema";

  const aplicar = tema => {
    const escuro = tema === "escuro";
    document.documentElement.dataset.tema = tema;
    document.querySelectorAll("[data-theme-toggle]").forEach(botao => {
      botao.setAttribute("aria-checked", String(escuro));
      botao.setAttribute("aria-label", escuro ? "Ativar tema claro" : "Ativar tema escuro");
    });
  };

  aplicar(localStorage.getItem(chave) || "claro");
  document.addEventListener("click", evento => {
    const botao = evento.target.closest("[data-theme-toggle]");
    if (!botao) return;
    const proximo = document.documentElement.dataset.tema === "escuro" ? "claro" : "escuro";
    localStorage.setItem(chave, proximo);
    aplicar(proximo);
  });
})();
