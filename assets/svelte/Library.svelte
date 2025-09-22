<script lang="ts">
  import type { AshSvelteAppLibraryBookResourceSchema as Book } from "../js/ash_rpc";
  let { books = [] }: { books: Book[] } = $props();
  $effect(() => {
    console.log("Books >>>", books);
  });
</script>

<section class="container bg-slate-50 border flex flex-col items-center justify-center">
  <h1 class="text-center text-2xl font-semibold">Library</h1>
  {#if books.length}
    <ul class="list">
      {#each books as book}
        <li id={book.id}>{book.title}</li>
      {/each}
    </ul>
  {/if}
  <pre>{JSON.stringify(books, null, 2)}</pre>
</section>
