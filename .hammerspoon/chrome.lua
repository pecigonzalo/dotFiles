-- Chrome
--
-- Some utility functions for controlling Chrome Browser.
--
-- NOTE: May require you enable View -> Developer -> Allow Javascript from
-- Apple Events in Brave's menu.

local module = {}

module.start = function(config_table)
  module.config = config_table
end

module.jump = function(url)
  hs.osascript.javascript([[
    var chrome = Application('Google Chrome');
    chrome.includeStandardAdditions = true
    chrome.activate();
    var found = false
    for (win of chrome.windows()) {
      var tabIndex =
        win.tabs().findIndex(tab => tab.url().match(/]] .. url .. [[/));
      if (tabIndex != -1) {
        win.activeTabIndex = (tabIndex + 1);
        win.index = 1;
      found = true
      break;
      }
    }
    if (!found) {
      newTab = chrome.Tab();
      chrome.windows[0].tabs.push(newTab);
      newTab.url = 'https://]] .. url .. [[';
    };
  ]])
end

return module
