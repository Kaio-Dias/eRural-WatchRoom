module.exports = {
  testEnvironment: 'jest-environment-jsdom',
  moduleFileExtensions: ['js', 'json', 'vue'],
  transform: {
    '.*\\.(vue)$': '@vue/vue3-jest',
    '.*\\.(js)$': 'babel-jest'
  },
  moduleNameMapper: {
    '^@/(.*)$': '<rootDir>/src/$1'
  }
}
