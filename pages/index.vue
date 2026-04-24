<template lang="pug">
div(class="w-1/2 min-w-[320px] mx-auto py-8")
  PrimeCard
    template(#header)
      h1(class="m-0") Welcome
  PrimeCard
    template(#header)
      h2(class="m-0") Things
    ul
      li
        PrimeButton(
          label="json.city"
          link
          :as="'a'"
          href="https://json.city"
          target="_blank"
        )
</template>
