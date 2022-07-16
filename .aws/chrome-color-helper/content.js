const accountId = document
  .querySelector('button[data-testid="awsc-copy-accountid"]')
  .previousElementSibling.innerText.replace(/\-/g, "");

color = accountColors[accountId];

if (color !== undefined) {
  document.querySelector("#awsc-nav-header>nav").style.backgroundColor = color;
} else {
  console.log("Account color not found");
}
