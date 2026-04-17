// Compile-time feature flags.
//
// Flip these to switch between UX variants without touching the
// feature code. Keep the set small — flags that outlive their
// experiment should either be promoted to real config or removed.

/// Multi-city search flow.
///
/// * `true`  — step-by-step leg-by-leg flow. The user picks a flight
///             for leg 1, then leg 2, then leg 3… and lands on the
///             review screen. Each leg hits the search API on its
///             own.
/// * `false` — single call. One search returns multi-city itinerary
///             combinations and the user books the whole trip from
///             the regular results screen like a round-trip.
const bool kMultiCityLegByLegFlow = false;
