/** @type {import('jest').Config} */
module.exports = {
  preset: "ts-jest",
  testEnvironment: "jsdom",
  testMatch: ["<rootDir>/src/**/*.test.{ts,tsx}"],
  setupFilesAfterEnv: ["<rootDir>/jest.setup.ts"],
  collectCoverageFrom: ["src/**/*.{ts,tsx}", "!src/**/*.test.{ts,tsx}"],
  coverageDirectory: "coverage",
  coverageReporters: ["text", "lcov"],
};
