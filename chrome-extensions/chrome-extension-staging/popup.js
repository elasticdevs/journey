document.addEventListener('DOMContentLoaded', function () {
  const loginBtn = document.getElementById('login-btn');
  const logoutBtn = document.getElementById('logout-btn');
  const addToJourneyBtn = document.getElementById('add-to-journey-btn');
  const loginSection = document.getElementById('login-section');
  const userSection = document.getElementById('user-section');
  const addToJourneyButton = document.getElementById('add-to-journey-button');
  const userName = document.getElementById('user-name');
  const userEmail = document.getElementById('user-email');
  const userPic = document.getElementById('user-pic');

  // Check if the user is already logged in
  chrome.identity.getAuthToken({ 'interactive': false }, function (token) {
    if (!chrome.runtime.lastError && token) {
      showUserSection();
      fetchUserInfo(token);
      // checkLinkedInProfile();
    } else {
      showLoginSection();
    }
  });

  loginBtn.addEventListener('click', function () {
    chrome.identity.getAuthToken({ 'interactive': true }, function (token) {
      if (chrome.runtime.lastError) {
        console.error(chrome.runtime.lastError);
        return;
      }

      // Save the access token under the specified domain
      chrome.storage.local.set({ 'access_token': token }, function () {
        if (chrome.runtime.lastError) {
          console.error(chrome.runtime.lastError);
          return;
        }

        showUserSection();
        fetchUserInfo(token);
        // checkLinkedInProfile();
      });
    });
  });

  logoutBtn.addEventListener('click', function () {
    chrome.identity.getAuthToken({ 'interactive': false }, function (currentToken) {
      if (!chrome.runtime.lastError && currentToken) {
        // Remove the access token from storage
        chrome.storage.local.remove('access_token', function () {
          if (chrome.runtime.lastError) {
            console.error(chrome.runtime.lastError);
            return;
          }
          console.log('Access token removed successfully.');
        });

        // Revoke the access token
        chrome.identity.removeCachedAuthToken({ 'token': currentToken }, function () {
          if (chrome.runtime.lastError) {
            console.error(chrome.runtime.lastError);
            return;
          }
          console.log('Access token revoked successfully.');
        });

        chrome.identity.launchWebAuthFlow(
          { 'url': 'https://accounts.google.com/logout' },
          function (tokenUrl) {
            responseCallback();
          }
        );

        showLoginSection();
      }
    });
  });

  addToJourneyBtn.addEventListener('click', function () {
    chrome.tabs.query({ active: true, currentWindow: true }, function (tabs) {
      const currentTab = tabs[0];
      if (currentTab) {
        console.log("ADD_TO_JOURNEY_READ_URL, current_url=" + currentTab.url)
        chrome.tabs.create({
          url: "https://staging.journey.im/clients/linkedin?linkedin=" + currentTab.url
        })
      }
    });
  });

  function showUserSection() {
    loginSection.style.display = 'none';
    userSection.style.display = 'flex';
  }

  function showLoginSection() {
    loginSection.style.display = 'block';
    userSection.style.display = 'none';
    addToJourneyButton.style.display = 'none';
  }

  function fetchUserInfo(token) {
    // Use the Google People API or any other relevant API to fetch user information
    // This is a placeholder and will not work without a proper implementation
    // Replace with your actual implementation
    fetch('https://www.googleapis.com/oauth2/v2/userinfo', {
      headers: {
        'Authorization': 'Bearer ' + token,
      },
    })
      .then(response => response.json())
      .then(data => {
        userName.textContent = data.name;
        userEmail.textContent = data.email;
        userPic.src = data.picture;
      })
      .catch(error => console.error('Error fetching user info:', error));
  }

  function updateAddToJourneyButton(tabId, changeInfo, tab) {
    chrome.identity.getAuthToken({ 'interactive': false }, function (token) {
      if (!chrome.runtime.lastError && token) {
        showUserSection();
        fetchUserInfo(token);
        if (changeInfo.status === 'complete' && tab.url.includes('linkedin.com/in/')) {
          addToJourneyButton.style.display = 'block';
        } else {
          addToJourneyButton.style.display = 'none';
        }
      } else {
        showLoginSection();
      }
    });
  }

  // Listen for tab activation changes
  chrome.tabs.onActivated.addListener(function (activeInfo) {
    chrome.tabs.get(activeInfo.tabId, function (tab) {
      updateAddToJourneyButton(activeInfo.tabId, { status: 'complete' }, tab);
    });
  });

  // Listen for tab URL changes
  chrome.tabs.onUpdated.addListener(function (tabId, changeInfo, tab) {
    updateAddToJourneyButton(tabId, changeInfo, tab);
  });

  // Call checkLinkedInProfile when the extension is opened
  chrome.tabs.query({ active: true, currentWindow: true }, function (tabs) {
    const currentTab = tabs[0];
    if (currentTab) {
      console.log("EXTENSION_OPENED_CHECK_URL, current_url=" + currentTab.url)
      updateAddToJourneyButton(currentTab.id, { status: 'complete' }, currentTab);
    }
  });
});
