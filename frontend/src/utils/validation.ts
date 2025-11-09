export const validateEmail = (email: string): boolean => {
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return emailRegex.test(email);
};

export const validatePassword = (password: string): { valid: boolean; errors: string[] } => {
  const errors: string[] = [];

  if (password.length < 6) {
    errors.push('Password must be at least 6 characters long');
  }

  return {
    valid: errors.length === 0,
    errors
  };
};

export const validateTime = (time: string): boolean => {
  // Validates MM:SS.SS or SS.SS format
  const timeRegex = /^(\d{1,2}:)?\d{1,2}\.\d{2}$/;
  return timeRegex.test(time);
};

export const validateDate = (date: string): boolean => {
  const dateObj = new Date(date);
  return dateObj instanceof Date && !isNaN(dateObj.getTime());
};
