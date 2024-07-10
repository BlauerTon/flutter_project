function fetchUserCount() {
  fetch('/get-authenticated-users')
      .then(response => response.json())
      .then(data => {
          if (data.totalUsers !== undefined) {
              document.getElementById('userCount').innerText = data.totalUsers;
          } else {
              document.getElementById('userCount').innerText = 'Error fetching user count';
          }
      })
      .catch(error => {
          console.error('Error fetching user count:', error);
          document.getElementById('userCount').innerText = 'Error fetching user count';
      });
}
fetchUserCount();