function [] = save_figure(name)
    pause
    export_fig(gcf,'-transparent', sprintf('figs/%s', name))
end