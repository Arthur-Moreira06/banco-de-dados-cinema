(() => {
  const menu = document.querySelector("[data-notification-menu]");
  if (!menu) return;

  const managerId = menu.dataset.managerId;
  const key = `cinema-notificacoes-vistas-${managerId}`;
  const toggle = menu.querySelector("[data-notification-toggle]");
  const panel = menu.querySelector("[data-notification-panel]");
  const badge = menu.querySelector("[data-notification-badge]");
  const list = menu.querySelector("[data-notification-list]");
  const caption = menu.querySelector("[data-notification-caption]");
  let latestId = 0;
  let lastSeenId = Number(localStorage.getItem(key));
  let hasSeenMarker = localStorage.getItem(key) !== null;

  const money = value => new Intl.NumberFormat("pt-BR", {
    style: "currency", currency: "BRL"
  }).format(Number(value || 0));

  function showUnread(count) {
    badge.hidden = count < 1;
    badge.textContent = count > 99 ? "99+" : String(count);
    toggle.setAttribute("aria-label", count ? `Notificações, ${count} não lidas` : "Notificações");
    caption.textContent = count ? `${count} venda${count === 1 ? " nova" : "s novas"}` : "Últimas vendas registradas";
  }

  function render(vendas) {
    list.replaceChildren();
    if (!vendas.length) {
      const empty = document.createElement("li");
      empty.className = "notification-empty";
      empty.textContent = "Nenhuma venda registrada ainda.";
      list.append(empty);
      return;
    }

    vendas.forEach(venda => {
      const item = document.createElement("li");
      item.className = "notification-item";
      item.classList.toggle("is-unread", Number(venda.id) > lastSeenId);

      const top = document.createElement("div");
      top.className = "notification-item__top";
      const title = document.createElement("strong");
      title.textContent = `Venda #${venda.id}`;
      const timestamp = document.createElement("time");
      timestamp.className = "notification-item__meta";
      const date = new Date(venda.dataVenda);
      timestamp.dateTime = venda.dataVenda;
      timestamp.textContent = Number.isNaN(date.getTime()) ? "" : new Intl.DateTimeFormat("pt-BR", {
        day: "2-digit", month: "2-digit", hour: "2-digit", minute: "2-digit"
      }).format(date);
      top.append(title, timestamp);

      const details = document.createElement("div");
      details.className = "notification-item__details";
      const employee = document.createElement("span");
      employee.textContent = `${venda.funcionario} · ${money(venda.valor)}`;
      details.append(employee);
      if (Number(venda.quantidadeIngressos) > 0) {
        const session = document.createElement("span");
        session.textContent = `${venda.quantidadeIngressos} ingresso${Number(venda.quantidadeIngressos) === 1 ? "" : "s"} · ${venda.sessoes}`;
        details.append(session);
      }
      if (venda.produtos) {
        const products = document.createElement("span");
        products.textContent = venda.produtos;
        details.append(products);
      }
      item.append(top, details);
      list.append(item);
    });
  }

  async function refresh() {
    const since = hasSeenMarker ? lastSeenId : -1;
    const response = await fetch(`/gerente/notificacoes?desdeId=${encodeURIComponent(since)}`, {
      headers: { Accept: "application/json" }
    });
    if (!response.ok) throw new Error("Falha ao consultar as vendas recentes.");
    const data = await response.json();
    latestId = Number(data.ultimoId || 0);
    render(data.vendas || []);

    if (!hasSeenMarker) {
      lastSeenId = latestId;
      localStorage.setItem(key, String(lastSeenId));
      hasSeenMarker = true;
      showUnread(0);
      render(data.vendas || []);
      return;
    }
    showUnread(Number(data.naoLidas || 0));
  }

  function markRead() {
    lastSeenId = Math.max(lastSeenId, latestId);
    localStorage.setItem(key, String(lastSeenId));
    hasSeenMarker = true;
    showUnread(0);
    list.querySelectorAll(".notification-item").forEach(item => item.classList.remove("is-unread"));
  }

  toggle.addEventListener("click", async () => {
    if (panel.hidden) {
      panel.hidden = false;
      toggle.setAttribute("aria-expanded", "true");
      try {
        await refresh();
        markRead();
      } catch {
        if (!list.querySelector(".notification-item, .notification-empty")) {
          const error = document.createElement("li");
          error.className = "notification-empty";
          error.textContent = "Não foi possível carregar as notificações.";
          list.append(error);
        }
      }
      return;
    }
    panel.hidden = true;
    toggle.setAttribute("aria-expanded", "false");
  });

  document.addEventListener("click", event => {
    if (panel.hidden || menu.contains(event.target)) return;
    panel.hidden = true;
    toggle.setAttribute("aria-expanded", "false");
  });
  document.addEventListener("keydown", event => {
    if (event.key !== "Escape" || panel.hidden) return;
    panel.hidden = true;
    toggle.setAttribute("aria-expanded", "false");
    toggle.focus();
  });

  refresh().catch(() => showUnread(0));
  window.setInterval(() => {
    if (!document.hidden) refresh().catch(() => {});
  }, 30000);
})();
