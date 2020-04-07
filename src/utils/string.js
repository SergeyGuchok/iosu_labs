export const makeFirstLetterUpperCase = (word) => {
  word = word.toLowerCase().split('')
  word[0] = word[0].toUpperCase()

  return word.join('');
}