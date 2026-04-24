<template lang="pug">
div(class="w-1/2 min-w-[320px] mx-auto py-8")
  Card
    template(#header)
      h1(class="m-0") Welcome
  Card
    template(#header)
      h2(class="m-0") Things
    ul
      li
        Button(
          label="json.city"
          link
          :as="'a'"
          href="https://json.city"
          target="_blank"
        )
</template>
