(() => {
  const menus = [...document.querySelectorAll("[data-user-menu]")];
  const fechar = menu => {
    menu.querySelector("[data-user-dropdown]").hidden = true;
    menu.querySelector("[data-user-menu-toggle]").setAttribute("aria-expanded", "false");
  };

  menus.forEach(menu => {
    const botao = menu.querySelector("[data-user-menu-toggle]");
    const painel = menu.querySelector("[data-user-dropdown]");
    botao.addEventListener("click", () => {
      const abrir = painel.hidden;
      menus.forEach(fechar);
      painel.hidden = !abrir;
      botao.setAttribute("aria-expanded", String(abrir));
    });
  });

  document.addEventListener("click", evento => {
    menus.forEach(menu => { if (!menu.contains(evento.target)) fechar(menu); });
  });
  document.addEventListener("keydown", evento => {
    if (evento.key !== "Escape") return;
    menus.forEach(menu => fechar(menu));
  });
})();
