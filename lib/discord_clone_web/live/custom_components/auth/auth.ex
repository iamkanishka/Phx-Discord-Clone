
defmodule DiscordCloneWeb.CustomComponents.Auth.Auth do
  use DiscordCloneWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""

    <div class="flex items-center justify-center min-h-fit bg-white">
      <div class="bg-white shadow-lg rounded-lg p-8 max-w-md w-full">
        <h2 class="text-2xl font-semibold mb-4">Sign in</h2>

        <p class="text-gray-600 mb-6">to continue to discord-clone</p>

    <!-- Google Login Button -->
        <a href="/auth/google" class="flex items">
          <button class="flex items-center justify-center w-full bg-white text-gray-700 py-2 px-4 rounded-lg border border-gray-300 mb-4 hover:bg-gray-200 transition">
            <img src="https://www.google.com/favicon.ico" alt="Google Icon" class="w-5 h-5 mr-2" />
            Continue with Google
          </button>
        </a>
        <!-- Divider -->
        <div class="flex items-center my-4">
          <div class="flex-grow h-px bg-gray-300"></div>
           <span class="px-3 text-gray-500 text-sm">or</span>
          <div class="flex-grow h-px bg-gray-300"></div>
        </div>

    <!-- Email Field -->
        <input
          type="email"
          placeholder="Email address"
          class="w-full p-3 border rounded-lg mb-4 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
        />

    <!-- password Field -->
        <input
          type="password"
          placeholder="Password"
          class="w-full p-3 border rounded-lg mb-4 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
        />

    <!-- Continue Button -->
        <button class="w-full bg-blue-600 text-white py-3 rounded-lg hover:bg-blue-700 transition">
          CONTINUE
        </button>

    <!-- Footer -->
        <p class="text-center text-gray-600 mt-4">
          No account? <a href="#" class="text-blue-600 hover:underline">Sign up</a>
        </p>
      </div>
    </div>

    """
  end

  @impl true
  def update(assigns, socket) do
    {:ok, socket |> assign(assigns)}
  end
end
