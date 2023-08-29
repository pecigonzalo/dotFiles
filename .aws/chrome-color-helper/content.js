const isElementLoaded = async (selector) => {
  while (document.querySelector(selector) === null) {
    await new Promise((resolve) => requestAnimationFrame(resolve));
  }
  return document.querySelector(selector);
};

isElementLoaded('button[data-testid="awsc-copy-accountid"]').then(
  (selector) => {
    const accountId = selector.previousElementSibling.innerText.replace(
      /\-/g,
      ""
    );

    color = accountColors[accountId];

    if (color !== undefined) {
      document.querySelector("#awsc-nav-header>nav").style.backgroundColor =
        color;
    } else {
      console.log("Account color not found");
    }
  }
);
