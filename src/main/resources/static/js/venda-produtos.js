(() => {
  const cards = [...document.querySelectorAll(".product-card")];
  const filters = [...document.querySelectorAll(".category-chip")];
  const productId = document.querySelector("#produtoId");
  const quantityInput = document.querySelector("#quantidade");
  const submitButton = document.querySelector("#submit-product-sale");
  const selectedSummary = document.querySelector("#selected-product");
  const purchaseHint = document.querySelector(".purchase-hint");
  const photoCatalog = {
    Pipoca: {
      products: {
        "pipoca grande": "pipoca-01-grande",
        "pipoca amanteigada grande": "pipoca-02-amanteigada-grande",
        "pipoca caramelizada": "pipoca-03-caramelizada",
        "pipoca com queijo": "pipoca-04-com-queijo",
        "pipoca doce crocante": "pipoca-05-doce-crocante",
        "pipoca salgada media": "pipoca-06-salgada-media",
        "pipoca com ervas": "pipoca-07-com-ervas",
        "pipoca de chocolate branco": "pipoca-08-chocolate-branco",
        "pipoca picante": "pipoca-09-picante",
        "pipoca familia": "pipoca-10-familia",
        "pipoca caramelo e flor de sal": "pipoca-11-caramelo-flor-sal",
        "pipoca cheddar": "pipoca-12-cheddar",
        "pipoca com canela": "pipoca-13-canela",
        "mini pipoca salgada": "pipoca-14-mini-salgada",
        "pipoca trufada": "pipoca-15-trufada",
        "pipoca barbecue": "pipoca-16-barbecue",
        "pipoca com leite condensado": "pipoca-17-leite-condensado",
        "pipoca lemon pepper": "pipoca-18-lemon-pepper",
        "pipoca classica pequena": "pipoca-19-classica-pequena",
        "pipoca meio amarga": "pipoca-20-meio-amarga",
        "pipoca parmesao": "pipoca-21-parmesao",
        "pipoca doce de canela": "pipoca-22-doce-canela",
        "pipoca caramelo intenso": "pipoca-23-caramelo-intenso",
        "pipoca manteiga extra": "pipoca-24-manteiga-extra",
        "pipoca mix da casa": "pipoca-25-mix-casa"
      },
      fallback: name => /barbecue|churrasco/.test(name) ? "pipoca-16-barbecue"
        : /truf/.test(name) ? "pipoca-15-trufada"
          : /familia|grande/.test(name) ? "pipoca-10-familia"
            : /mini|classica pequena/.test(name) ? "pipoca-19-classica-pequena"
              : /lemon|pepper/.test(name) ? "pipoca-18-lemon-pepper"
                : /parmes/.test(name) ? "pipoca-21-parmesao"
                  : /erva|herb/.test(name) ? "pipoca-07-com-ervas"
                    : /picante|pimenta/.test(name) ? "pipoca-09-picante"
                      : /cheddar|queijo/.test(name) ? "pipoca-12-cheddar"
                        : /condensado/.test(name) ? "pipoca-17-leite-condensado"
                          : /chocolate/.test(name) ? "pipoca-20-meio-amarga"
                            : /canela/.test(name) ? "pipoca-22-doce-canela"
                              : /caramelo|caramel/.test(name) ? "pipoca-23-caramelo-intenso"
                                : /manteiga|amanteigada/.test(name) ? "pipoca-24-manteiga-extra"
                                  : /doce/.test(name) ? "pipoca-05-doce-crocante"
                                    : /mix/.test(name) ? "pipoca-25-mix-casa"
                                      : "pipoca-06-salgada-media"
    },    Bebida: {
      products: {
        "refrigerante 500ml": "bebida-01-refrigerante-500ml",
        "agua mineral": "bebida-02-agua-mineral",
        "agua mineral sem gas": "bebida-03-agua-mineral-sem-gas",
        "refrigerante de cola": "bebida-04-refrigerante-cola",
        "suco de laranja natural": "bebida-05-suco-laranja-natural",
        "cha gelado de pessego": "bebida-06-cha-gelado-pessego",
        "guarana lata": "bebida-07-guarana-lata",
        "agua com gas": "bebida-08-agua-com-gas",
        "suco de uva integral": "bebida-09-suco-uva-integral",
        "limonada da casa": "bebida-10-limonada-da-casa",
        "cola zero": "bebida-11-cola-zero",
        "cha mate com limao": "bebida-12-cha-mate-limao",
        "suco de maracuja": "bebida-13-suco-maracuja",
        "refrigerante de laranja": "bebida-14-refrigerante-laranja",
        "agua de coco": "bebida-15-agua-coco",
        "soda italiana de maca": "bebida-16-soda-italiana-maca",
        "refrigerante de limao": "bebida-17-refrigerante-limao",
        "suco de abacaxi": "bebida-18-suco-abacaxi",
        "cha verde gelado": "bebida-19-cha-verde",
        "agua tonica": "bebida-20-agua-tonica",
        "chocolate quente": "bebida-21-chocolate-quente",
        "cafe gelado": "bebida-22-cafe-gelado",
        "milk-shake de baunilha": "bebida-23-milkshake-baunilha",
        "milk-shake de chocolate": "bebida-24-milkshake-chocolate",
        "suco de morango": "bebida-25-suco-morango",
        "refrigerante de gengibre": "bebida-26-refrigerante-gengibre"
      },
      fallback: name => {
        if (/coco/.test(name)) return "bebida-15-agua-coco";
        if (/mate|cha.*limao/.test(name)) return "bebida-12-cha-mate-limao";
        if (/cha.*verde/.test(name)) return "bebida-19-cha-verde";
        if (/cha|pessego/.test(name)) return "bebida-06-cha-gelado-pessego";
        if (/tonica/.test(name)) return "bebida-20-agua-tonica";
        if (/limonada/.test(name)) return "bebida-10-limonada-da-casa";
        if (/cola zero|zero/.test(name)) return "bebida-11-cola-zero";
        if (/guarana/.test(name)) return "bebida-07-guarana-lata";
        if (/gengibre/.test(name)) return "bebida-26-refrigerante-gengibre";
        if (/laranja/.test(name)) return "bebida-14-refrigerante-laranja";
        if (/limao/.test(name)) return "bebida-17-refrigerante-limao";
        if (/maracuja/.test(name)) return "bebida-13-suco-maracuja";
        if (/abacaxi/.test(name)) return "bebida-18-suco-abacaxi";
        if (/morango/.test(name)) return "bebida-25-suco-morango";
        if (/uva/.test(name)) return "bebida-09-suco-uva-integral";
        if (/suco|fruta/.test(name)) return "bebida-05-suco-laranja-natural";
        if (/milk.shake|shake|baunilha/.test(name)) return "bebida-23-milkshake-baunilha";
        if (/cafe/.test(name)) return "bebida-22-cafe-gelado";
        if (/chocolate/.test(name)) return "bebida-21-chocolate-quente";
        if (/gas|carbonatada/.test(name)) return "bebida-08-agua-com-gas";
        if (/agua|mineral/.test(name)) return "bebida-02-agua-mineral";
        if (/soda|maca|italiana/.test(name)) return "bebida-16-soda-italiana-maca";
        return "bebida-04-refrigerante-cola";
      }
    },
    Doce: {
      products: {
        "chocolate m&ms": "doce-01-chocolate-mms",
        "chocolate ao leite": "doce-02-chocolate-ao-leite",
        "trufa de maracuja": "doce-03-trufa-maracuja",
        "bala de gelatina": "doce-04-bala-gelatina",
        "brownie com nozes": "doce-05-brownie-nozes",
        "barra de cereal": "doce-06-barra-cereal",
        "cookie de chocolate": "doce-07-cookie-chocolate",
        "goma de mascar": "doce-08-goma-mascar",
        "pacoca artesanal": "doce-09-pacoca-artesanal",
        "chocolate amargo": "doce-10-chocolate-amargo",
        "bala de caramelo": "doce-11-bala-caramelo",
        "alfajor argentino": "doce-12-alfajor-argentino",
        "pe de moleque": "doce-13-pe-moleque",
        "trufa de avela": "doce-14-trufa-avela",
        "biscoito amanteigado": "doce-15-biscoito-amanteigado",
        "bala de frutas": "doce-16-bala-frutas",
        "doce de leite": "doce-17-doce-leite",
        "bombom de coco": "doce-18-bombom-coco",
        "cookie de baunilha": "doce-19-cookie-baunilha",
        "chiclete de menta": "doce-20-chiclete-menta",
        "barra de castanhas": "doce-21-barra-castanhas",
        "mini bolo de cenoura": "doce-22-mini-bolo-cenoura",
        "brigadeiro gourmet": "doce-23-brigadeiro-gourmet",
        "chocolate com amendoim": "doce-24-chocolate-amendoim",
        "suspiro artesanal": "doce-25-suspiro-artesanal"
      },
      fallback: name => /suspiro/.test(name) ? "doce-25-suspiro-artesanal"
        : /chiclete|goma|menta/.test(name) ? "doce-20-chiclete-menta"
          : /bala.*fruta|fruta.*bala/.test(name) ? "doce-16-bala-frutas"
            : /bala|gelatina/.test(name) ? "doce-04-bala-gelatina"
              : /caramel|caramelo/.test(name) ? "doce-11-bala-caramelo"
                : /alfajor/.test(name) ? "doce-12-alfajor-argentino"
                  : /truf|brigadeiro/.test(name) ? "doce-14-trufa-avela"
                    : /bombom|coco|beijinho/.test(name) ? "doce-18-bombom-coco"
                      : /brownie|bolo/.test(name) ? "doce-05-brownie-nozes"
                        : /cereal/.test(name) ? "doce-06-barra-cereal"
                          : /castanha|barra/.test(name) ? "doce-21-barra-castanhas"
                            : /cookie|baunilha/.test(name) ? "doce-19-cookie-baunilha"
                              : /biscoito/.test(name) ? "doce-15-biscoito-amanteigado"
                                : /pacoca/.test(name) ? "doce-09-pacoca-artesanal"
                                  : /amendoim|pe de moleque/.test(name) ? "doce-13-pe-moleque"
                                    : /leite/.test(name) ? "doce-17-doce-leite"
                                      : /chocolate/.test(name) ? "doce-02-chocolate-ao-leite"
                                        : "doce-01-chocolate-mms"
    },
    Combo: {
      products: {
        "combo sessao classica": "combo-01-sessao-classica",
        "combo pipoca e cola": "combo-02-pipoca-cola",
        "combo casal especial": "combo-03-casal-especial",
        "combo familia": "combo-04-familia",
        "combo doce e bebida": "combo-05-doce-bebida",
        "combo matine": "combo-06-matine",
        "combo noite de estreia": "combo-07-noite-estreia",
        "combo intervalo rapido": "combo-08-intervalo-rapido",
        "combo pipoca caramelizada": "combo-09-pipoca-caramelizada",
        "combo cinema em dobro": "combo-10-cinema-dobro",
        "combo infantil": "combo-11-infantil",
        "combo nachos e refrigerante": "combo-12-nachos-refrigerante",
        "combo cafe e brownie": "combo-13-cafe-brownie",
        "combo para amigos": "combo-14-para-amigos",
        "combo economico": "combo-15-economico",
        "combo grande aventura": "combo-16-grande-aventura",
        "combo sabor da casa": "combo-17-sabor-casa",
        "combo pipoca e suco": "combo-18-pipoca-suco",
        "combo lancamento": "combo-19-lancamento",
        "combo classico para dois": "combo-20-classico-dois",
        "combo ferias": "combo-21-ferias",
        "combo chocolate quente": "combo-22-chocolate-quente",
        "combo edicao especial": "combo-23-edicao-especial",
        "combo sessao premium": "combo-24-sessao-premium",
        "combo casal (pipoca + 2 refrigerantes)": "combo-03-casal-especial"
      },
      fallback: name => /nacho/.test(name) ? "combo-12-nachos-refrigerante"
        : /cafe|brownie/.test(name) ? "combo-13-cafe-brownie"
          : /chocolate quente/.test(name) ? "combo-22-chocolate-quente"
            : /doce|trufa|lancamento|premium|estreia/.test(name) ? "combo-19-lancamento"
              : /familia|aventura|infantil|matine|ferias/.test(name) ? "combo-16-grande-aventura"
                : /suco/.test(name) ? "combo-18-pipoca-suco"
                  : /amigos|casal|dois|dobro/.test(name) ? "combo-14-para-amigos"
                    : /economico|intervalo|rapido/.test(name) ? "combo-15-economico"
                      : /caramel/.test(name) ? "combo-09-pipoca-caramelizada"
                        : "combo-01-sessao-classica"
    },
    Outro: {
      products: {
        "nachos com queijo": "outro-01-nachos-queijo",
        "hot dog tradicional": "outro-02-hotdog-tradicional",
        "sanduiche de frango": "outro-03-sanduiche-frango",
        "batata chips artesanal": "outro-04-batata-chips",
        "biscoito salgado": "outro-05-biscoito-salgado",
        "mini pizza marguerita": "outro-06-mini-pizza",
        "pao de queijo": "outro-07-pao-queijo",
        "wrap de vegetais": "outro-08-wrap-vegetais",
        "pretzel salgado": "outro-09-pretzel",
        "torrada temperada": "outro-10-torrada-temperada",
        "cachorro-quente especial": "outro-11-hotdog-especial",
        "sanduiche caprese": "outro-12-sanduiche-caprese",
        "empada de palmito": "outro-13-empada-palmito",
        "pastel assado": "outro-14-pastel-assado",
        "mix de castanhas": "outro-15-mix-castanhas",
        "tiras de frango": "outro-16-tiras-frango",
        "aneis de cebola": "outro-17-aneis-cebola",
        "focaccia italiana": "outro-18-focaccia",
        "croissant misto": "outro-19-croissant-misto",
        "esfiha de queijo": "outro-20-esfiha-queijo",
        "bruschetta": "outro-21-bruschetta",
        "batata rustica": "outro-22-batata-rustica",
        "pao de alho": "outro-23-pao-alho",
        "snack de grao-de-bico": "outro-24-snack-grao-bico"
      },
      fallback: name => /nacho/.test(name) ? "outro-01-nachos-queijo"
        : /hot dog|cachorro quente/.test(name) ? "outro-02-hotdog-tradicional"
          : /sanduiche de frango|tira.*frango/.test(name) ? "outro-16-tiras-frango"
            : /sanduiche|caprese/.test(name) ? "outro-12-sanduiche-caprese"
              : /wrap|vegetais/.test(name) ? "outro-08-wrap-vegetais"
                : /chips/.test(name) ? "outro-04-batata-chips"
                  : /batata/.test(name) ? "outro-22-batata-rustica"
                    : /biscoito|cracker/.test(name) ? "outro-05-biscoito-salgado"
                      : /pizza/.test(name) ? "outro-06-mini-pizza"
                        : /pao de queijo/.test(name) ? "outro-07-pao-queijo"
                          : /pretzel/.test(name) ? "outro-09-pretzel"
                            : /torrada/.test(name) ? "outro-10-torrada-temperada"
                              : /empada|palmito/.test(name) ? "outro-13-empada-palmito"
                                : /pastel/.test(name) ? "outro-14-pastel-assado"
                                  : /castanha/.test(name) ? "outro-15-mix-castanhas"
                                    : /cebola/.test(name) ? "outro-17-aneis-cebola"
                                      : /focaccia|pao de alho/.test(name) ? "outro-18-focaccia"
                                        : /croissant/.test(name) ? "outro-19-croissant-misto"
                                          : /esfiha/.test(name) ? "outro-20-esfiha-queijo"
                                            : /bruschetta/.test(name) ? "outro-21-bruschetta"
                                              : /grao|grão/.test(name) ? "outro-24-snack-grao-bico"
                                                : "outro-08-wrap-vegetais"
    }
  };
  window.cinemaProductImage = (category, productName) => {
    const key = String(productName || "").normalize("NFD").replace(/[\u0300-\u036f]/g, "").toLowerCase();
    const catalog = photoCatalog[category] || photoCatalog.Outro;
    return `/css/${catalog.products[key] ?? catalog.fallback(key)}.png?v=8`;
  };
  if (!document.querySelector("#product-purchase-form")) return;
  const sourceImageSize = 1254;
  const sourceCellSize = 410;
  const sourceCellStep = 422;
  const categoryKey = { Pipoca: "Pipoca", Bebida: "Bebida", Doce: "Doce", Combo: "Combo", Outro: "Outro" };
  let selectedCard = null;

  const money = (value) => new Intl.NumberFormat("pt-BR", {
    style: "currency", currency: "BRL"
  }).format(value);

  function photoCell(card) {
    const category = categoryKey[card.dataset.category] ? card.dataset.category : "Outro";
    const name = card.dataset.productName.normalize("NFD").replace(/[\u0300-\u036f]/g, "").toLowerCase();
    const catalog = photoCatalog[category];
    if (["Pipoca", "Bebida", "Doce", "Combo", "Outro"].includes(category)) {
      return { image: window.cinemaProductImage(category, card.dataset.productName), direct: true };
    }
    const tile = catalog.products[name] ?? catalog.fallback(name);
    return { image: catalog.src, row: Math.floor(tile / 3), column: tile % 3 };
  }

  function applyPhoto(photo, card) {
    const tileSize = photo.clientWidth;
    if (!tileSize) return;
    const { image, row, column, direct } = photoCell(card);
    photo.style.backgroundImage = `url("${image}")`;
    if (direct) {
      photo.style.backgroundSize = "cover";
      photo.style.backgroundPosition = "center";
      return;
    }
    const scale = tileSize / sourceCellSize;
    photo.style.backgroundSize = `${sourceImageSize * scale}px ${sourceImageSize * scale}px`;
    photo.style.backgroundPosition = `${-column * sourceCellStep * scale}px ${-row * sourceCellStep * scale}px`;
  }

  function quantityFor(card) {
    return Number(card.querySelector(".quantity-value").value || card.querySelector(".quantity-value").textContent);
  }

  function updateTotal() {
    if (!selectedCard || !quantityInput.value) return;
    const price = Number(selectedCard.dataset.productPrice);
    const quantity = Number(quantityInput.value);
    document.querySelector("#selected-product-total").textContent = `Total: ${money(price * quantity)}`;
  }

  function selectProduct(card) {
    selectedCard = card;
    productId.value = card.dataset.productId;
    const quantity = quantityFor(card);
    quantityInput.value = quantity;
    quantityInput.max = card.dataset.stock;
    quantityInput.disabled = false;
    submitButton.disabled = false;

    document.querySelector("#selected-product-category").textContent = card.dataset.category;
    document.querySelector("#selected-product-name").textContent = card.dataset.productName;
    document.querySelector("#selected-product-price").textContent = `${money(Number(card.dataset.productPrice))} por unidade`;
    const image = card.querySelector(".product-photo");
    const selectedImage = document.querySelector("#selected-product-photo");
    selectedImage.className = `selected-product__photo ${[...image.classList].find(name => name.startsWith("product-photo--")) || ""}`;
    selectedSummary.hidden = false;
    applyPhoto(selectedImage, card);
    purchaseHint.hidden = true;
    cards.forEach(item => item.classList.toggle("is-selected", item === card));
    updateTotal();
    document.querySelector("#purchase-section").scrollIntoView({ behavior: "smooth", block: "start" });
  }

  filters.forEach(filter => filter.addEventListener("click", () => {
    const category = filter.dataset.filter;
    filters.forEach(item => {
      const active = item === filter;
      item.classList.toggle("is-active", active);
      item.setAttribute("aria-pressed", String(active));
    });
    cards.forEach(card => {
      card.hidden = category !== "Todas" && card.dataset.category !== category;
    });
  }));

  cards.forEach(card => {
    const photo = card.querySelector(".product-photo");
    applyPhoto(photo, card);
    card.querySelector(".product-card__select").addEventListener("click", () => selectProduct(card));
    const controls = card.querySelector(".quantity-control");
    controls.querySelectorAll(".quantity-step").forEach(button => button.addEventListener("click", () => {
      const output = controls.querySelector(".quantity-value");
      const next = Math.min(Number(card.dataset.stock), Math.max(1, Number(output.textContent) + Number(button.dataset.step)));
      output.textContent = String(next);
      if (selectedCard === card) {
        quantityInput.value = String(next);
        updateTotal();
      }
    }));
  });

  if ("ResizeObserver" in window) {
    const photoObserver = new ResizeObserver(entries => {
      entries.forEach(entry => {
        const card = entry.target.closest(".product-card");
        if (card) applyPhoto(entry.target, card);
      });
      if (selectedCard) applyPhoto(document.querySelector("#selected-product-photo"), selectedCard);
    });
    cards.forEach(card => photoObserver.observe(card.querySelector(".product-photo")));
  } else {
    window.addEventListener("resize", () => {
      cards.forEach(card => applyPhoto(card.querySelector(".product-photo"), card));
      if (selectedCard) applyPhoto(document.querySelector("#selected-product-photo"), selectedCard);
    });
  }

  quantityInput.addEventListener("input", () => {
    if (!selectedCard) return;
    const max = Number(selectedCard.dataset.stock);
    const value = Math.max(1, Math.min(max, Number(quantityInput.value || 1)));
    quantityInput.value = String(value);
    selectedCard.querySelector(".quantity-value").textContent = String(value);
    updateTotal();
  });
})();
