import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { swimmersService } from '../services/swimmers.service';
import type { Swimmer } from '../types/swimmer.types';

export const useSwimmers = () => {
  return useQuery({
    queryKey: ['swimmers'],
    queryFn: swimmersService.getAll,
  });
};

export const useSwimmer = (seId: string) => {
  return useQuery({
    queryKey: ['swimmer', seId],
    queryFn: () => swimmersService.getById(seId),
    enabled: !!seId,
  });
};

export const useCreateSwimmer = () => {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: (swimmer: Partial<Swimmer>) => swimmersService.create(swimmer),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['swimmers'] });
    },
  });
};

export const useUpdateSwimmer = () => {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: ({ seId, swimmer }: { seId: string; swimmer: Partial<Swimmer> }) =>
      swimmersService.update(seId, swimmer),
    onSuccess: (_, variables) => {
      queryClient.invalidateQueries({ queryKey: ['swimmers'] });
      queryClient.invalidateQueries({ queryKey: ['swimmer', variables.seId] });
    },
  });
};

export const useDeleteSwimmer = () => {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: (seId: string) => swimmersService.delete(seId),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['swimmers'] });
    },
  });
};
