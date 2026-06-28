# ---- Build stage ----
FROM rustlang/rust:nightly-bookworm AS builder

WORKDIR /bot

RUN apt-get update && apt-get install -y cmake mold clang && apt-get clean

COPY . .

RUN cargo build --release

# ---- Runtime stage ----
FROM debian:bookworm-slim

RUN apt-get update && apt-get upgrade -y \
    && apt-get install -y ca-certificates ffmpeg \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /bot/target/release/tts_bot /usr/local/bin/discord_tts_bot

CMD ["/usr/local/bin/discord_tts_bot"]
