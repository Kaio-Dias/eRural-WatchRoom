import { shallowMount } from '@vue/test-utils'
import YouTubePlayer from '@/components/YouTubePlayer.vue'

describe('YouTubePlayer.vue', () => {
  it('renders the component', () => {
    window.YT = {
      Player: jest.fn().mockImplementation(() => ({
        destroy: jest.fn()
      }))
    }

    const wrapper = shallowMount(YouTubePlayer, {
      props: { videoId: 'test' }
    })
    expect(wrapper.exists()).toBe(true)
  })
})