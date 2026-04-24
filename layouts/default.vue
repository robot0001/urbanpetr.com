<template lang="pug">
Menubar(:model="navItems")
  template(#item="{ item, props }")
    NuxtLink(v-if="item.route" :to="item.route" v-bind="props.action") {{ item.label }}
slot
</template>

<script setup lang="ts">
const navItems = [
  { label: 'Home', route: '/' },
  { label: 'About', route: '/about' }
]
</script>
