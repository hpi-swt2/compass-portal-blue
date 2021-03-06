// Returns a modified version of `f` that only runs if the last call is longer
// than `limit` ms ago.
export function rateLimit(f, limit) {
  let locked = false;
  return (...args) => {
    if (!locked) {
      locked = true;
      setTimeout(() => locked = false, limit);
      return f(...args);
    }
  };
}

// Returns a function that calls return the value returned by `initializer`.
// Repeated calls return the same value returned by the first call.
// In order to work properly, `initializer` should not return `null`.
export function lazyInit(initializer) {
  let value = null;
  return () => {
    if (value === null) {
      value = initializer();
    }
    return value;
  };
}

// The `lazyinit` is needed, because the `querySelector` seems to, somewhat
// randomly, block the execution of the script in our tests. This is a
// workaround, until a real solution is found.
export const csrfToken = lazyInit(() => document.querySelector('meta[name="csrf-token"]').getAttribute("content"));
export const userSignedIn = lazyInit(() => document.querySelector('meta[name="user_signed_in"]') !== null);
