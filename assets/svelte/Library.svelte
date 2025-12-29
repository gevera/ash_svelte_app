<script lang="ts">
  import { type BookResourceSchema as Book, getAll } from "../js/ash_rpc";
  let { books = [], live }: { books: Book[]; live: any } = $props();
  let currentSelectedBook: Book | null = $state(null);
  let deleteBookModal: HTMLDialogElement | null = $state(null);
  $effect(() => {
    console.log("Books >>>", books);
  });
  const handleSubmit = (e: SubmitEvent) => {
    e.preventDefault();
    const formData = new FormData(e.currentTarget as HTMLFormElement);
    const title = formData.get("title") as string;
    const author = formData.get("author") as string;
    const isbn = formData.get("isbn") as string;
    live.pushEvent("ADD_BOOK", {
      title,
      author,
      isbn,
    });
  };

  const showDeleteBookModal = (book: Book) => {
    currentSelectedBook = book;
    deleteBookModal.showModal();
  };
  const handleDelete = () => {
    if (currentSelectedBook) {
      live.pushEvent("DELETE_BOOK", { id: currentSelectedBook.id });
      deleteBookModal.close();
      currentSelectedBook = null;
    }
  };
</script>

<section
  class="bg-slate-50 flex flex-col items-center justify-center mx-auto pp"
>
  <h1 class="text-center text-2xl font-semibold">Library</h1>
  <div class="my-5 w-full max-w-md mx-auto">
    <form onsubmit={handleSubmit} class="flex flex-col gap-2">
      <input
        type="text"
        name="title"
        required
        placeholder="Title"
        class="input"
      />
      <input
        type="text"
        name="author"
        required
        placeholder="Author"
        class="input"
      />
      <input type="text" name="isbn" placeholder="ISBN" class="input" />
      <button type="submit" class="btn">Add new book</button>
    </form>
  </div>
  {#if books.length}
    <ul class="disc">
      {#each books as book}
        <li class="text-lg font-semibold" id={book.id}>
          {book.title}
          <button
            class="btn btn-sm btn-ghost btn-secondary"
            onclick={() => showDeleteBookModal(book)}>x</button
          >
        </li>
      {/each}
    </ul>
  {/if}
  <!-- Use RPC call instead of LiveView onMount props -->
  {#await getAll({ fields: [] })}
    <div>Loading ...</div>
  {:then data}
    <div class="mockup-code w-full">
      <pre class=""><code>{JSON.stringify(data, null, 2)}</code></pre>
    </div>
  {:catch error}
    <div>{error}</div>
  {/await}
</section>

<dialog id="delete_book_modal" class="modal modal-middle" bind:this={deleteBookModal}>
  <div class="modal-box">
    <h3 class="text-lg font-bold">
      Are you sure you want to delete this book?
    </h3>
    <p class="py-4">This action cannot be undone.</p>
    <div class="modal-action flex gap-5 justify-between">
      <button class="btn btn-primary" onclick={handleDelete}>Delete</button>
      <button class="btn btn-secondary" onclick={() => deleteBookModal.close()}
        >Cancel</button
      >
    </div>
  </div>
  <form method="dialog" class="modal-backdrop">
    <button>close</button>
  </form>
</dialog>
