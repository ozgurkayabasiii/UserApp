document.addEventListener("turbo:load", function() {
    const searchInput = document.getElementById('search_input');
    const searchResults = document.getElementById('search_results');
  
    function performSearch(query) {
      fetch(`/users/search?search=${encodeURIComponent(query)}`, {
        headers: {
          'Accept': 'text/vnd.turbo-stream.html',
          'X-Requested-With': 'XMLHttpRequest'
        },
        cache: "no-store"
      })
      .then(response => {
        if (!response.ok) {
          throw new Error('Network response was not ok');
        }
        return response.text();
      })
      .then(html => {
        const parser = new DOMParser();
        const doc = parser.parseFromString(html, 'text/html');
        const turboStreamElement = doc.querySelector('turbo-stream');
          const template = turboStreamElement.querySelector('template').innerHTML;
          searchResults.innerHTML = template;
      })
      .catch(error => {
        console.error('Error fetching search results:', error);
      });
    }
  
    if (searchInput) {
      searchInput.addEventListener('input', () => {
        performSearch(searchInput.value.trim());
      });
    }
  
    const clearSearchButton = document.getElementById('clear_search');
    if (clearSearchButton) {
      clearSearchButton.addEventListener('click', () => {
        searchInput.value = '';
        performSearch('');
      });
    }
  });
  