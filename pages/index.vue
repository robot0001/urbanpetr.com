<template lang="pug">
Panel(header="Welcome to UrbanPetr.com" class="mb-8")
  p Hi, I'm Petr Urban — a software engineer based in Prague.


div(class="flex flex-col lg:flex-row gap-6")
  div(class="flex flex-col gap-6 lg:w-2/3")
    Card
      template(#title) Latest Work
      template(#content)
        p Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation.
    Card
      template(#title) Featured Projects
      template(#content)
        p Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident.
  div(class="flex flex-col gap-6 lg:w-1/3")
    Panel(header="Links")
      ul
        li
          a(href="https://json.city" target="_blank") json.city
    Panel(header="Quick Info")
      p Consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore.
</template>
