<script setup lang="ts">
const route = useRoute()
const myStuffOpen = ref(false)
const introActive = ref(true)

const isMyStuff = computed(() => route.path.startsWith('/my-stuff'))
watch(() => route.path, () => { myStuffOpen.value = false })

let timer: ReturnType<typeof setTimeout> | null = null

onMounted(() => {
  timer = setTimeout(() => { introActive.value = false }, 4550)
})

onUnmounted(() => { if (timer) clearTimeout(timer) })
</script>

<template lang="pug">
div(
  id="app-container"
  :class="[introActive ? 'bg-flat-dark' : 'bg-flat-cream', 'min-h-screen font-sans relative transition-colors duration-500']"
)
  div(
    v-if="introActive"
    class="fixed inset-0 z-40 pointer-events-none flex items-center justify-center"
  )
    div(class="animate-overlay-decay absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-[calc(50%+45px)] text-zinc-500/80 font-mono text-[11px] tracking-[0.25em] uppercase text-center w-full") Initiating Smooth Ease-In-Out Zoom

  div(
    :class="introActive ? 'fixed inset-0 w-screen h-screen overflow-hidden pointer-events-none origin-center bg-flat-cream z-30 animate-portal-scale' : 'relative bg-flat-cream min-h-screen'"
  )
    div(
      v-if="introActive"
      class="absolute inset-0 z-50 pointer-events-none animate-white-melt"
    )

    header(class="sticky top-0 z-40 bg-flat-cream border-b-[2px] border-flat-dark shadow-[0_4px_0px_rgba(17,26,46,0.08)]")
      div(class="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 h-16 flex items-center justify-between gap-4")
        div(class="flex items-center gap-3 flex-shrink-0")
          div(class="w-8 h-8 bg-flat-yellow border-2 border-flat-dark flex items-center justify-center font-display font-bold text-flat-dark text-sm shadow-[2px_2px_0px_rgba(17,26,46,1)]") P
          div(class="flex flex-col leading-tight")
            span(class="font-display font-black text-xs tracking-widest uppercase text-flat-dark") URBANPETR.COM

        nav(class="hidden md:flex items-center gap-1 text-xs font-mono font-bold tracking-wider")
          NuxtLink(to="/" class="nav-link") HOME
          NuxtLink(to="/about" class="nav-link") ABOUT
          div(class="relative")
            button(
              @click="myStuffOpen = !myStuffOpen"
              :class="['nav-link flex items-center gap-1.5 cursor-pointer', isMyStuff ? 'nav-link-active' : '']"
            )
              span MY STUFF
              i(
                class="pi pi-chevron-down text-[10px] transition-transform duration-200"
                :class="myStuffOpen ? 'rotate-180' : ''"
              )
            div(v-if="myStuffOpen" class="fixed inset-0 z-40" @click="myStuffOpen = false")
            div(
              v-if="myStuffOpen"
              class="absolute top-full left-0 mt-2 z-50 min-w-max bg-flat-cream border-2 border-flat-dark shadow-[4px_4px_0px_rgba(17,26,46,1)] py-1"
            )
              NuxtLink(
                to="/my-stuff/now-watching"
                class="block px-4 py-2 text-xs font-mono font-bold text-flat-dark hover:bg-flat-yellow transition-colors"
                @click="myStuffOpen = false"
              ) NOW WATCHING

    main(class="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 py-12")
      slot

    footer(class="bg-flat-dark text-zinc-400 py-10 border-t-[3px] border-flat-dark mt-12")
      div(class="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 flex flex-col md:flex-row items-center justify-between gap-6 text-xs font-mono")
        div(class="flex items-center gap-3")
          div(class="w-8 h-8 bg-flat-yellow text-flat-dark flex items-center justify-center font-bold font-display text-[11px] border-2 border-flat-dark shadow-[2px_2px_0px_rgba(255,255,255,1)]") P
          span(class="font-black text-white uppercase tracking-widest") URBANPETR.COM
        p(class="text-zinc-500 font-sans font-bold text-xs") Flat brutalist design. Pure CSS entry animation.
        span © 2026 Petr Urban
</template>

<style scoped>
.nav-link {
  color: #111a2e;
  padding: 4px 8px;
  border: 1px solid transparent;
  transition: all 0.15s;
  display: inline-flex;
  align-items: center;
}

.nav-link:hover,
.nav-link.router-link-exact-active,
.nav-link-active {
  background: #ffd214;
  border-color: #111a2e;
  color: #111a2e;
}
</style>
