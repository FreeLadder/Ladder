package com.example.yogaxiong.ladder;

import android.animation.Animator;
import android.animation.AnimatorListenerAdapter;
import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.animation.DecelerateInterpolator;
import android.widget.TextView;

import java.util.List;

/**
 * Created by YogaXiong on 2017/4/10.
 */


public class LadderAdapter extends RecyclerView.Adapter<LadderAdapter.LadderViewHolder> implements View.OnClickListener {
    private Context mContext;
    private List<Ladder> ladders;
    private int lastAnimatedPosition=-1;
    private boolean animationsLocked = false;
    private boolean delayEnterAnimation = true;
    private OnRecyclerViewItemClickListener mOnItemClickListener = null;
    public static interface OnRecyclerViewItemClickListener {
        void onItemClick(View view , Ladder data);
    }

    public LadderAdapter(Context mContext, List<Ladder> ladders) {
        super();
        this.mContext = mContext;
        this.ladders = ladders;
    }

    public void setLadders(List<Ladder> ladders) {
        this.ladders = ladders;
    }

    @Override
    public int getItemCount() {
        return ladders.size();
    }

    @Override
    public LadderViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(mContext).inflate(R.layout.ladder_list_item, parent, false);
        LadderViewHolder holder = new LadderViewHolder(view);
        view.setOnClickListener(this);
        return holder;
    }

    @Override
    public void onBindViewHolder(LadderViewHolder holder, int position) {
        runEnterAnimation(holder.itemView,position);
        Ladder ladder = ladders.get(position);
        holder.ipTextView.setText(ladder.getIpText());
        holder.portTextView.setText(ladder.getPortText());
        holder.passwordTextView.setText(ladder.getPasswordText());
        holder.encryptionTextView.setText(ladder.getEncriptionText());

        holder.itemView.setTag(ladder);
    }

    private void runEnterAnimation(View view, int position) {


        if (animationsLocked) return;//animationsLocked是布尔类型变量，一开始为false，确保仅屏幕一开始能够显示的item项才开启动画


        if (position > lastAnimatedPosition) {//lastAnimatedPosition是int类型变量，一开始为-1，这两行代码确保了recycleview滚动式回收利用视图时不会出现不连续的效果
            lastAnimatedPosition = position;
            view.setTranslationY(500);//相对于原始位置下方500
            view.setAlpha(0.f);//完全透明
            //每个item项两个动画，从透明到不透明，从下方移动到原来的位置
            //并且根据item的位置设置延迟的时间，达到一个接着一个的效果
            view.animate()
                    .translationY(0).alpha(1.f)//设置最终效果为完全不透明，并且在原来的位置
                    .setStartDelay(delayEnterAnimation ? 20 * (position) : 0)//根据item的位置设置延迟时间，达到依次动画一个接一个进行的效果
                    .setInterpolator(new DecelerateInterpolator(0.5f))//设置动画效果为在动画开始的地方快然后慢
                    .setDuration(400)
                    .setListener(new AnimatorListenerAdapter() {
                        @Override
                        public void onAnimationEnd(Animator animation) {
                            animationsLocked = true;//确保仅屏幕一开始能够显示的item项才开启动画，也就是说屏幕下方还没有显示的item项滑动时是没有动画效果
                        }
                    })
                    .start();
        }
    }
    class LadderViewHolder extends RecyclerView.ViewHolder {
        public TextView ipTextView;
        public TextView portTextView;
        public TextView passwordTextView;
        public TextView encryptionTextView;

        public LadderViewHolder(View view) {
            super(view);
            ipTextView = (TextView) view.findViewById(R.id.tv_ip);
            portTextView = (TextView) view.findViewById(R.id.tv_port);
            passwordTextView = (TextView) view.findViewById(R.id.tv_password);
            encryptionTextView = (TextView) view.findViewById(R.id.tv_encryption);
        }
    }

    @Override
    public void onClick(View v) {
        if (mOnItemClickListener != null) {
            mOnItemClickListener.onItemClick(v, (Ladder)v.getTag());
        }
    }

    public void setmOnItemClickListener(OnRecyclerViewItemClickListener mOnItemClickListener) {
        this.mOnItemClickListener = mOnItemClickListener;
    }



}