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

    account = accounts[accountId];
    console.log(`Account: ${account.name} - ${account.color}`);

    const accountColor = account.color;
    if (accountColor !== undefined) {
      document.querySelector("#awsc-nav-header>nav").style.backgroundColor =
        accountColor;
    } else {
      console.log("Account color not found");
    }

    const accountName = account.name;
    if (accountName !== undefined) {
      document.querySelector(
        '[data-testid="awsc-nav-account-menu-button"]>span[title]'
      ).textContent = accountName;
    } else {
      console.log("Account name not found");
    }
  }
);
