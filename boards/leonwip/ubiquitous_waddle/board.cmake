# Copyright (c) 2025 leonwip
# SPDX-License-Identifier: Apache-2.0

board_runner_args(jlink "--device=stm32g0b1ke" "--speed=4000")

include(${ZEPHYR_BASE}/boards/common/jlink.board.cmake)
