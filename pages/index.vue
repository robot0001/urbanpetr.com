<template lang="pug">
Panel(header="Welcome to UrbanPetr.com")
  p Hi, I'm Petr Urban — a software engineer based in Prague.

Splitter(class="mt-4")
  SplitterPanel(:size="70" :minSize="40")
    Card
      template(#title) Latest Work
      template(#content)
        p Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation.
    Card(class="mt-4")
      template(#title) Featured Projects
      template(#content)
        p Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident.
  SplitterPanel(:size="30" :minSize="20")
    Panel(header="Links")
      ul
        li
          a(href="https://json.city" target="_blank") json.city
    Panel(header="Quick Info" class="mt-4")
      p Consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore.
</template>
