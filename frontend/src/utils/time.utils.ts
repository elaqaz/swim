export const formatTime = (seconds: number): string => {
  if (!seconds) return '';

  const mins = Math.floor(seconds / 60);
  const secs = (seconds % 60).toFixed(2);

  if (mins > 0) {
    return `${mins}:${secs.padStart(5, '0')}`;
  }
  return secs;
};

export const parseTime = (timeStr: string): number | null => {
  if (!timeStr) return null;

  const parts = timeStr.split(':');

  if (parts.length === 2) {
    // MM:SS.SS format
    const mins = parseInt(parts[0]);
    const secs = parseFloat(parts[1]);
    return mins * 60 + secs;
  } else if (parts.length === 1) {
    // SS.SS format
    return parseFloat(parts[0]);
  }

  return null;
};

export const formatTimeDifference = (diff: number): string => {
  const sign = diff >= 0 ? '+' : '-';
  return `${sign}${formatTime(Math.abs(diff))}`;
};
