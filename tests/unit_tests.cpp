#include <gtest/gtest.h>
#include "../math_operations.h"

TEST(BasicAddition, HandlesPositiveNumbers) {
    EXPECT_EQ(add(2, 3), 5);
}

TEST(BasicAddition, HandlesNegativeAndPositive) {
    EXPECT_EQ(add(-1, 1), 0);
}

TEST(BasicAddition, HandlesZeros) {
    EXPECT_EQ(add(0, 0), 0);
}

int main(int argc, char **argv) {
    ::testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}
