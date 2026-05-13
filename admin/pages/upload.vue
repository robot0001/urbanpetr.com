<script setup lang="ts">
const { public: { apiBase } } = useRuntimeConfig()
const { token, login } = useAuth()

const fileInput = ref<HTMLInputElement>()
const selectedFile = ref<File | null>(null)
const uploading = ref(false)
const result = ref<{ total: number; created: number } | null>(null)
const error = ref<string | null>(null)

function onFileChange(e: Event) {
  selectedFile.value = (e.target as HTMLInputElement).files?.[0] ?? null
  result.value = null
  error.value = null
}

async function upload() {
  if (!selectedFile.value) return

  uploading.value = true
  result.value = null
  error.value = null

  const form = new FormData()
  form.append('file', selectedFile.value)

  try {
    const data = await $fetch<{ total: number; created: number }>(
      `${apiBase}/v1/history/youtube/ingest`,
      {
        method: 'POST',
        body: form,
        headers: token.value ? { Authorization: `Bearer ${token.value}` } : {},
      }
    )
    result.value = data
    selectedFile.value = null
    if (fileInput.value) fileInput.value.value = ''
  } catch (e: any) {
    if (e?.response?.status === 401) {
      login()
    } else {
      error.value = e?.data?.error ?? 'Upload failed'
    }
  } finally {
    uploading.value = false
  }
}
</script>

<template lang="pug">
div
  h1(class="text-xl font-semibold mb-6") Upload Watch History
  Card
    template(#content)
      div(class="flex flex-col gap-4")
        p(class="text-sm" :style="{ color: 'var(--p-text-muted-color)' }")
          | Upload a zipped Google Takeout YouTube watch history file. Duplicate entries are ignored automatically.

        div(class="flex items-center gap-3 flex-wrap")
          input(
            ref="fileInput"
            type="file"
            accept=".zip"
            class="hidden"
            @change="onFileChange"
          )
          Button(
            label="Choose file"
            icon="pi pi-folder-open"
            severity="secondary"
            @click="fileInput?.click()"
          )
          span(
            class="text-sm"
            :style="{ color: 'var(--p-text-muted-color)' }"
          ) {{ selectedFile ? selectedFile.name : 'No file selected' }}

        Button(
          label="Upload"
          icon="pi pi-upload"
          :disabled="!selectedFile"
          :loading="uploading"
          @click="upload"
        )

        Message(v-if="error" severity="error" :closable="false") {{ error }}

        Message(v-if="result" severity="success" :closable="false")
          | Imported {{ result.created }} new item{{ result.created !== 1 ? 's' : '' }} out of {{ result.total }} in the file.
</template>
