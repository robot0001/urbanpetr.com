<template lang="pug">
Panel(header="Hey there" class="mb-8")
  p Computer enthusiast who's deeply into software development, team leadership, and currently obsessed with AI tools and what they can do.
  p Based in Prague, always tinkering.

div(class="flex flex-col lg:flex-row gap-6")
  div(class="flex flex-col gap-6 lg:w-2/3")
    Card
      template(#title) What I'm Into Right Now
      template(#content)
        p Toying around with AI—exploring various tools, seeing how they fit into development workflows. Building things faster, thinking differently. Later I'll document actual projects here.
        p
          strong openclaw
          | &nbsp;is taking up most of my bandwidth. It's the kind of project that keeps you up at night in the best way possible.
  div(class="flex flex-col gap-6 lg:w-1/3")
    Panel(header="Links")
      ul
        li
          a(href="https://json.city" target="_blank") json.city
</template>
