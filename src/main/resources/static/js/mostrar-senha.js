document.addEventListener("click", event => {
  const botao = event.target.closest("[data-password-toggle]");
  if (!botao) return;

  const campo = botao.parentElement.querySelector("input");
  if (!campo) return;

  const mostrar = campo.type === "password";
  campo.type = mostrar ? "text" : "password";
  botao.setAttribute("aria-pressed", String(mostrar));
  botao.setAttribute("aria-label", mostrar ? "Ocultar senha" : "Mostrar senha");
  botao.querySelector("[data-password-hidden-icon]").toggleAttribute("hidden", mostrar);
  botao.querySelector("[data-password-visible-icon]").toggleAttribute("hidden", !mostrar);
});
