import { format, parseISO } from 'date-fns';

export const formatDate = (date: string | Date): string => {
  if (!date) return '';

  const dateObj = typeof date === 'string' ? parseISO(date) : date;
  return format(dateObj, 'dd MMM yyyy');
};

export const formatDateTime = (date: string | Date): string => {
  if (!date) return '';

  const dateObj = typeof date === 'string' ? parseISO(date) : date;
  return format(dateObj, 'dd MMM yyyy HH:mm');
};

export const formatDateForInput = (date: string | Date): string => {
  if (!date) return '';

  const dateObj = typeof date === 'string' ? parseISO(date) : date;
  return format(dateObj, 'yyyy-MM-dd');
};

export const calculateAge = (dob: string | Date, referenceDate?: string | Date): number => {
  const dobDate = typeof dob === 'string' ? parseISO(dob) : dob;
  const refDate = referenceDate
    ? (typeof referenceDate === 'string' ? parseISO(referenceDate) : referenceDate)
    : new Date();

  let age = refDate.getFullYear() - dobDate.getFullYear();
  const monthDiff = refDate.getMonth() - dobDate.getMonth();

  if (monthDiff < 0 || (monthDiff === 0 && refDate.getDate() < dobDate.getDate())) {
    age--;
  }

  return age;
};
